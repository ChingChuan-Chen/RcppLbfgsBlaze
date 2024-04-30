## RcppLbfgsblaze

`RcppLbfgsblaze` leverage [blaze-lib](https://bitbucket.org/blaze-lib/blaze/src/master/) and [LBFGS-Lite](https://github.com/ZJU-FAST-Lab/LBFGS-Lite) to provide the light and fast L-BFGS algorithm on `R` which also export the header for usage in `Rcpp`.

### Installation

You can install:

* the latest development version from github with

    ```R
    install.packages("remotes")
    remotes::install_github("ChingChuan-Chen/RcppLbfgsblaze")
    ```

If you encounter a bug, please file a reproducible example on [github](https://github.com/ChingChuan-Chen/RcppLbfgsblaze/issues).

### Example

You may refer [this file](./inst/example.cpp) for the example code.

### Authors

Ching-Chuan Chen

### License

MIT License
