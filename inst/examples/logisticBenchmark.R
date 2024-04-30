## Copyright (C) 2024 Ching-Chuan Chen
##
## This file is part of RcppLbfgsBlaze.
##
## RcppLbfgsBlaze is free software: you can redistribute it and/or modify it
## under the terms of the MIT License. You should have received
## a copy of MIT License along with RcppLbfgsBlaze.
## If not, see https://opensource.org/license/mit.

suppressPackageStartupMessages({
  require(stats)
  require(microbenchmark)
  require(RcppBlaze)
  require(glmnet)
  require(lbfgs)
  require(RcppNumerical)
})

## define different versions of lm
exprs <- list()

# default version used in lm()
exprs$glm.fit <- expression(stats::glm.fit(X1, y, family = binomial()))
exprs$optim <- expression(optim(rep(0, ncol(X1)), likelihood, gradient, X = X1, y = y, method = "L-BFGS"))
exprs$lbfgs <- expression(lbfgs(
  likelihood, gradient, rep(0, ncol(X1)), X = X1, y = y, m = 8, past = 4,
  linesearch_algorithm = "LBFGS_LINESEARCH_BACKTRACKING",
  invisible = TRUE
))
exprs$lbfgs_cpp <- expression(lbfgs(
  likelihood_cpp, gradient_cpp, rep(0, ncol(X1)), X = X1, y = y, m = 8, past = 4,
  linesearch_algorithm = "LBFGS_LINESEARCH_BACKTRACKING",
  invisible = TRUE
))
exprs$RcppNumerical_fastLR <- expression(fastLR(X1, as.numeric(y)))
exprs$RcppNumerical <- expression(rcpp_numerical_logistic(rep(0, ncol(X1)), X1, as.numeric(y)))
exprs$glmnet <- expression(glmnet(X, y, lambda = 0, family = "binomial", standardize=FALSE))
# exprs$RcppLbfgsBlaze <- expression(fastLogisticModel(X1, as.numeric(y)))

rcppNumericalLogisticCode <- '
// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::depends(RcppNumerical)]]
#include <RcppNumerical.h>
using namespace Numer;

class LogisticModel: public MFuncGrad {
public:
  LogisticModel(const Eigen::Map<Eigen::MatrixXd> &X, const Eigen::Map<Eigen::VectorXd> &y) : X(X), y(y) {}

  double f_grad(Constvec& b, Refvec grad) {
    Eigen::VectorXd eta = (X * b).array().max(-30).min(30);
    Eigen::VectorXd phat = 1/(1 + (-eta).array().exp());
    grad = X.transpose() * (phat - y);
    return -eta.dot(y) - (1 - phat.array()).log().sum();
  }
private:
  const Eigen::Map<Eigen::MatrixXd> X;
  const Eigen::Map<Eigen::VectorXd> y;
};

// [[Rcpp::export]]
Rcpp::List rcpp_numerical_logistic(
    const Eigen::Map<Eigen::VectorXd> &coef_init,
    const Eigen::Map<Eigen::MatrixXd> X,
    const Eigen::Map<Eigen::VectorXd> y
) {
  double likelihood = 0.0;
  Eigen::VectorXd coef = coef_init;
  LogisticModel lm(X, y);
  int res = optim_lbfgs(lm, coef, likelihood);

  return Rcpp::List::create(
    Rcpp::Named("value") = likelihood,
    Rcpp::Named("par") = coef,
    Rcpp::Named("status") = res
  );
}'


do_bench <- function(n = 1e4L, p = 100L, non_zero_pro = 0.05, nrep = 20L, suppressSVD = (n > 1e5L || p > 2e2L)) {
  nzc <- ceiling(p*non_zero_pro/2)
  X <- matrix(rnorm(n * p), n, p)
  beta <- c(rnorm(nzc, 2, 0.4), rnorm(nzc, -2, 0.4), rep(0, p - 2 * nzc))
  y <- sapply(1/(1 + exp(-2 - X %*% beta)), function(p) rbinom(1, 1, p), USE.NAMES = FALSE)
  X1 <- cbind(1, X)

  likelihood <- function(par, X, y) {
    eta <- pmin(pmax(X %*% par, -30), 30)
    phat <- 1/(1+exp(-eta))
    -crossprod(eta, y) - sum(log(1 - phat))
  }

  gradient <- function(par, X, y) {
    eta <- pmin(pmax(X %*% par, -30), 30)
    phat <- 1/(1+exp(-eta))
    t(X) %*% (phat - y)
  }

  likelihood_cpp <- Rcpp::cppFunction("double likelihood_cpp(const arma::vec& par, const arma::mat& X, const arma::vec& y) {
    arma::vec eta = arma::clamp(X * par, -30, 30);
    arma::vec phat = 1/(1 + arma::exp(-eta));
    return -arma::dot(eta, y) - arma::sum(arma::log(1 - phat));
  }", depends = "RcppArmadillo")

  gradient_cpp <- Rcpp::cppFunction("arma::vec gradient_cpp(const arma::vec& par, const arma::mat& X, const arma::vec& y) {
    arma::vec eta = arma::clamp(X * par, -30, 30);
    arma::vec phat = 1/(1 + arma::exp(-eta));
    return X.t() * (phat - y);
  }", depends = "RcppArmadillo")

  Rcpp::sourceCpp(code = rcppNumericalLogisticCode)
  cat("logistic model benchmark for n = ", n, ", p = ", p, " and non-zero p = ", nzc*2, ": nrep = ", nrep, "\n", sep="")
  microbenchmark(list = do.call(c, exprs), times = nrep)
}

print(do_bench())
