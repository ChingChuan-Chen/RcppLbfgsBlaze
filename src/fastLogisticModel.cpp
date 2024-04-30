// Copyright (C)  2024  Ching-Chuan Chen
//
// This file is part of RcppLbfgsBlaze.
//
// RcppLbfgsBlaze is free software: you can redistribute it and/or modify it
// under the terms of the MIT License. You should have received
// a copy of MIT License along with RcppLbfgsBlaze.
// If not, see https://opensource.org/license/mit.

#include <RcppBlaze.h>
#include <lbfgs.h>
using Rcpp::_;

class LogisticModelFitting {
public:
  blaze::DynamicMatrix<double> X;
  blaze::DynamicVector<double> y;

  LogisticModelFitting(Rcpp::NumericMatrix X_, Rcpp::NumericVector y_) {
    X = Rcpp::as<blaze::DynamicMatrix<double>>(X_);
    y = Rcpp::as<blaze::DynamicVector<double>>(y_);
  }

  Rcpp::List run(Rcpp::NumericVector coef_) {
    // initialize coef
    int p = coef_.size();
    std::size_t coef_padded_size = blaze::nextMultiple<std::size_t>((size_t)p, blaze::SIMDTrait<double>::size);
    std::unique_ptr<double[], blaze::Deallocate> data(blaze::allocate<double>(coef_padded_size));
    lbfgs::BlazeVector coef(data.get(), (size_t)p, coef_padded_size);
    RcppBlaze::copyToCustomVector(coef_, coef);

    // Set the minimization parameters
    lbfgs::lbfgs_parameter_t params;
    params.g_epsilon = 1.0e-5;
    params.delta = 1.0e-5;

    // Start minimization
    double final_value = 0.0;
    // int result = lbfgs::lbfgs_optimize(coef, final_value, cost_function, nullptr, nullptr, this, params);

    return Rcpp::List::create(
      _["value"] = final_value,
      _["par"] = coef,
      _["lbfgs_result_code"] = 0 // result
    );
  }

private:
  double cost_function(void *instance, const lbfgs::BlazeVector &coef, lbfgs::BlazeVector &grad) {
    blaze::DynamicVector<double> eta = blaze::max(blaze::min(X * coef, 30.0), -30.0);
    blaze::DynamicVector<double> phat = 1/(1 + blaze::exp(-eta));
    double fx = -blaze::dot(eta, y) - blaze::sum(blaze::log(1 - phat));
    grad = blaze::trans(X) * (phat - y);
    return fx;
  }
};

//' Logistic Regression Fitting Using L-BFGS Algorithm
//'
//' This function leverage \code{blaze} and \code{LBFGS-Blaze} to efficiently fit logistic regression.
//'
//' @param X The model matrix.
//' @param y The response vector.
//' @return A list of L-BFGS optimization result.
//'
//' @examples
//' X <- matrix(rnorm(5000), 1000)
//' coef <- runif(100, -3, 3)
//' y <- sapply(1 / (1 + exp(-X %*% coef)), function(p) rbinom(1, 1, p), USE.NAMES = FALSE)
//'
//' fit <- fastLogisticModel(x, y)
//' @export
// [[Rcpp::export]]
Rcpp::List fastLogisticModel(Rcpp::NumericMatrix X, Rcpp::NumericVector y) {
  LogisticModelFitting lm(X, y);
  Rcpp::NumericVector coef(X.ncol());
  std::fill(coef.begin(), coef.end(), 0.0);
  return lm.run(coef);
}
