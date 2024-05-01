## RcppLbfgsblaze

This package provides an implementation of the `L-BFGS` algorithm based on `Blaze` for `R` and `Rcpp`. 
The `L-BFGS` algorithm is a popular optimization algorithm for unconstrained optimization problems. 
`Blaze` is a high-performance `C++` math library for dense and sparse arithmetic. 
The package provides a simple interface to the `L-BFGS` algorithm and allows users to optimize 
their objective functions with Blaze vectors and matrices in `R` and `Rcpp`.

### Installation

You can install:

* the latest development version from github with

    ```R
    install.packages("remotes")
    remotes::install_github("ChingChuan-Chen/RcppLbfgsblaze")
    ```

If you encounter a bug, please file a reproducible example on [github](https://github.com/ChingChuan-Chen/RcppLbfgsblaze/issues).

### Logistic Model Fitting Benchmark

You can refer to the file [logisticBenchmark.R](./inst/examples/logisticBenchmark.R) to find the code.
Below code and corresponding results show that `RcppLbfgsblaze` provides a fast and efficient algorithm for logistic model fitting.

    ```R
    source(system.file("examples", "logisticBenchmark.R", package = "RcppLbfgsBlaze"))
    # logistic model fitting benchmark for n = 10000, p = 100 and non-zero p = 6: nrep = 20
    # Unit: milliseconds
    #                  expr      min        lq       mean    median        uq       max neval
    #               glm.fit 257.2170 265.93285 293.117575 283.57680 326.71545  340.7858    20
    #                 optim  61.2161  65.67600  72.287470  68.37055  72.12120  145.2132    20
    #            optim_arma  15.6136  16.28550  17.508120  17.24370  18.32525   21.6505    20
    #        RcppLbfgsBlaze  10.8729  11.34015  12.102315  11.75275  12.45615   15.3221    20
    #                glmnet  37.2798  38.96865 130.402930  40.38960  42.04705 1832.7456    20
    #                 lbfgs 173.2924 184.05055 468.719820 191.19040 209.56535 5572.6373    20
    #            lbfgs_arma  40.5532  42.05420  44.566345  44.34010  46.38210   51.1474    20
    #  RcppNumerical_fastLR   9.2105   9.52110   9.863155   9.68595  10.29325   10.9466    20
    #         RcppNumerical   3.2204   3.38860   4.044365   3.72145   4.07455    7.9843    20
    ```

Above results are run on my desktop (i9-13900K, DDR5-4000 128GB).

### Authors

Ching-Chuan Chen

### License

MIT License
