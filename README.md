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
    #                  expr      min        lq      mean    median        uq       max neval
    #               glm.fit 261.0691 266.81105 297.08549 285.28720 332.21190  360.8385    20
    #                 optim  64.2125  66.73465  76.09674  70.72650  75.11450  130.4458    20
    #            optim_arma  14.6350  16.29500  16.89384  16.58730  17.65345   18.7868    20
    #        RcppLbfgsBlaze  11.0940  11.39880  12.18345  11.58235  12.32980   17.1177    20
    #                glmnet  35.5173  36.80800  39.19770  38.45920  40.90995   49.3444    20
    #                 lbfgs 172.1253 177.55015 364.55791 183.31630 210.26880 1965.5255    20
    #            lbfgs_arma  38.7453  39.99275 129.23829  41.43080  45.03150 1762.4927    20
    #  RcppNumerical_fastLR   8.5466   8.92255   9.40195   9.15430   9.52455   13.4580    20
    #         RcppNumerical   3.4105   3.78210   4.40715   4.30210   4.71540    8.1145    20
    ```

Above results are run on my desktop (i9-13900K, DDR5-4000 128GB).

### Authors

Ching-Chuan Chen

### License

MIT License
