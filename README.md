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
    source(system.file("examples", "logisticBenchmark.R", package = "RcppLbfgsblaze"))
    # logistic model benchmark for n = 10000, p = 100 and non-zero p = 6: nrep = 20
    # Unit: milliseconds
    #                  expr      min        lq      mean    median        uq      max neval
    #               glm.fit 292.2610 297.44375 328.12950 305.31330 354.25390 481.3507    20
    #                 optim  98.3145 104.73180 109.80494 108.17890 111.60800 143.1004    20
    #                 lbfgs 187.2514 196.62335 208.11745 202.21505 210.09110 286.0543    20
    #             lbfgs_cpp  43.6178  45.01485  46.79239  45.39475  46.89445  56.0291    20
    #  RcppNumerical_fastLR   9.9168  11.00495  11.41928  11.23135  11.59345  15.3489    20
    #         RcppNumerical   4.1587   4.35205   4.85189   4.85275   5.27710   5.5805    20
    #                glmnet  37.6238  39.39010  41.75343  41.32335  42.96875  49.1623    20
    ```

Above results are run on my desktop (i9-13900K, DDR5-4000 128GB).

### Authors

Ching-Chuan Chen

### License

MIT License
