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
    #                  expr        min         lq       mean     median        uq      max neval
    #               glm.fit 255.809901 261.045151 276.380391 264.622901 281.89935 340.9089    20
    #                 optim  65.574401  71.753300  79.942356  75.657851  80.75455 142.3766    20
    #                 lbfgs 209.106701 223.820001 241.420176 230.909851 243.48555 317.1975    20
    #             lbfgs_cpp  49.506900  51.013250  53.210191  52.398551  54.82675  59.0651    20
    #  RcppNumerical_fastLR   8.894501   9.427351  10.582966   9.966651  10.32275  23.5838    20
    #         RcppNumerical   3.898502   4.106651   4.734516   4.494201   5.20320   6.6632    20
    #                glmnet  33.552301  34.844251  36.574931  36.013801  37.57470  43.2909    20
    #        RcppLbfgsBlaze  10.779001  11.156951  11.804186  11.856651  12.10440  14.5253    20
    ```

Above results are run on my desktop (i9-13900K, DDR5-4000 128GB).

### Authors

Ching-Chuan Chen

### License

MIT License
