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
    #             expr      min        lq       mean    median        uq      max neval
    #          glm.fit 252.3733 260.56465 272.921020 267.54365 275.75880 342.0555    20
    #            optim  64.7884  68.37525  74.520170  71.13575  74.64360 139.2025    20
    #       optim_arma  15.4986  16.22255  16.901825  16.60925  17.91680  18.7066    20
    #           glmnet  37.5449  40.54650  47.557280  42.83230  46.13685 120.1372    20
    #            lbfgs 179.8177 191.48075 201.447170 195.58680 206.31010 271.1675    20
    #       lbfgs_arma  41.6792  45.53480  47.548250  46.85675  49.67780  55.0899    20
    #    RcppNumerical   9.0517   9.38490   9.985235   9.72375  10.54195  11.3252    20
    #   RcppLbfgsBlaze  11.4112  12.09620  12.448380  12.40520  12.64770  14.5763    20
    ```

Above results are run on my desktop (i9-13900K, DDR5-4000 128GB).

### Authors

Ching-Chuan Chen

### License

MIT License
