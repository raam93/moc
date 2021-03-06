#' Counterfactual Explanations
#' 
#' \code{Counterfactuals} are calculated with a multi-niching NSGA-II. 
#' The method is available in the package mosmafs, which is based on the package ecr.
#' 
#' @format \code{\link{R6Class}} object.
#' @name Counterfactuals
#' @section Usage:
#' \preformatted{
#' cf = Counterfactuals$new(predictor, x.interest = NULL, target = NULL, 
#' epsilon = NULL, fixed.features = NULL, max.changed = NULL, 
#' mu = 50, generations = 50, p.mut = 0.2, p.rec = 0.9, p.mut.gen = 0.5,
#' p.mut.use.orig = 0.2, p.rec.gen = 0.7, p.rec.use.orig = 0.7,
#' use.ice.curve.var = FALSE, lower = NULL, upper = NULL, 
#' crow.dist.version = 1, sd.for.init = FALSE)
#' 
#' plot(cf)
#' cf$results
#' cf$log
#' print(cf)
#' cf$explain(x.interest, target)
#' cf$subset_results(nr.solutions)
#' cfs$continue_search(generations)
#' cf$plot_statistics()
#' cf$calculate_hv()
#' cf$calculate_diversity()
#' cf$calculate_freq(plot = FALSE)
#' }
#' 
#' @section Arguments: 
#' For Counterfactuals$new()
#' \describe{
#' \item{predictor: }{(Predictor)\cr 
#' The object (created with Predictor$new()) holding the machine learning model and the data.}
#' \item{x.interest: }{(data.frame)\cr  Single row with the instance to be explained.}
#' \item{target: }{(numeric(1)|numeric(2))\cr Desired outcome either a single numeric or 
#' a vector of two numerics, to define a desired interval as outcome.}
#' \item{epsilon: }{(numeric(1))\cr Soft constraint. If chosen, candidates, whose
#' distance between their prediction and target exceeds epsilon, are penalized.
#' Default is NULL.}
#' \item{fixed.features: }{(character|numeric)\cr 
#' Name or index of feature(s), which are not allowed to be changed. 
#' Index refers to ordering of feature names of data used to initialize predictor.
#' Default is NULL.} 
#' \item{max.changed: }{integer(1)\cr Maximum number of features that can be changed.
#' Default is NULL.}
#' \item{mu: }{(integer(1))\cr Population size.
#' Default is 50.}
#' \item{generations: }{(integer(1))\cr Number of generations. Default is 50.}
#' \item{p.mut: }{numeric(1)\cr Probability a child is chosen to be mutated.
#' Default is 0.2.}
#' \item{p.rec: }{numeric(1)\cr Probability a pair of parents is chosen to recombine. 
#' Default is 0.9.}
#' \item{p.mut.gen:}{numeric(1)\cr Probability one feature/gene is mutated. 
#' Default is 0.5.}
#' \item{p.mut.use.orig:}{numeric(1)\cr Probability an element of the indicator 
#' to use the feature value of x.interest is mutated. As hamming weight 
#' bitflip mutation is used, only a probability between 0 and 0.5 is allowed. 
#' Default is 0.2.}
#' \item{p.rec.gen:}{numeric(1)\cr Probability one feature/gene is recombined.
#' Default is 0.7.}
#' \item{p.rec.use.orig:}{numeric(1)\cr Probability an elment of the indicator
#' to use the feature values of x.interest is recombined.
#' Default is 0.7.} 
#' \item{lower:}{numeric\cr Vector of minimal values for numeric features. If NULL
#' (default) lower is extracted from input data specified in field 'data' of 'predictor'.}
#' \item{upper: }{numeric\cr Vector of maximal values for numeric features. 
#' If NULL (default) upper is extracted from input data specified in field 'data' of 
#' 'predictor'.}
#' \item{use.ice.curve.var:}{logical(1)\cr Whether ICE curve variance should be used to 
#' initialize population. Default is FALSE.}
#' \item{crow.dist.version: }{integer(1)\cr Which crowding distance version should be
#'  used. The default 1 corresponds to the version of Avila et. al., 2 corresponds 
#' to a modified version of Avila et. al. originally used for reducing the number
#' of returned solutions, 3 corresponds to the originally version of Deb et. al.} 
#' \item{sd.for.init: }{logical(1)\cr Whether to use standard deviation 
#' extracted from observed dataset to sample numeric features for the
#' initial population. Default is FALSE.}
#' \item{track.infeas: }{logical(1)\cr Whether to add a fourth objective that 
#' evaluates minimum Gower distance to observed data set. Default is TRUE.}
#' \item{penalize infeas: }{}
#' }
#' 
#' @section Methods:
#' \describe{
#' \item{\code{explain(x.interest, target)}}{Method to set a new data point which to explain.}
#' \item{\code{plot()}}{Method to plot the Pareto front in 2-D. See \link{plot.Counterfactuals.}}
#' \item{\code{plotStatistics()}}{Method to plot information of Counterfactuals$log 
#' for evaluation of algorithm.}
#' \item{\code{continue_search(generations)}}{Method to continue search 
#' after run was already finished. Results are automatically updated in 
#' Counterfactuals$results.}
#' \item{\code{calculate_hv()}}{Calculate dominated hypervolume of Counterfactual set 
#' equal to fitness.dominatedHV of last row in Counterfactuals$log, .}
#' \item{\code{calculate_diversity()}}{Calculate diversity of Counterfactual set
#' equal to population.div of last row in Counterfactuals$log.}
#' \item{\code{calculate_frequency()}}{Calculate frequency a feature got changed 
#' over the returned set of Counterfactuals.}
#' \item{\code{clone()}}{[internal] Method to clone the R6 object.}
#' \item{\code{initialize()}}{[internal] Method to initialize the R6 object.}
#' \item{\code{subset_results(nr.solutions)}}{Returns a subset of Counterfactuals 
#' as in Counterfactuals$results of the size of nr. solutions.}
#' }
#'
#' @references 
#' \describe{
#' \item{Bossek, J. (2017). ecr 2.0: A modular framework for evolutionary computation in r,
#' Proceedings of the Genetic and Evolutionary Computation Conference Companion,
#' GECCO '17, pp. 1187-1193.}{}
#' \item{Deb, K., Pratap, A., Agarwal, S. and Meyarivan, T. (2002). A fast and elitist multiobjective
#' genetic algorithm: Nsga-ii, IEEE Transactions on Evolutionary Computation
#' 6(2): 182-197.}{}
#' \item{Avila, S. L.,  Kraehenbuehl, L. and Sareni, B. (2006). A multi-niching 
#' multi-objective genetic algorithm for solving complex multimodal problems, 
#' OIPE, Sorrento, Italy.}{}
#' } 
#' 
#' @seealso 
#' A different way to explain predictions: \link{LocalModel}, \link{Shapley}
#' 
#' @examples 
#' if (require("randomForest")) {
#' # First we fit a machine learning model on the Boston housing data
#' data("Boston", package  = "MASS")
#' rf =  randomForest(medv ~ ., data = Boston)
#' X = Boston[-which(names(Boston) == "medv")]
#' mod = Predictor$new(rf, data = X)
#'
#' # Then we explain the prediction of the first instance with the 
#' # Counterfactuals method
#' x.interest = X[1,]
#' target = 30
#' counterfactual = Counterfactuals$new(mod, x.interest = x.interest, 
#' target = target, generations = 10)
#' counterfactual
#'
#' # Look at the results in a table
#' counterfactual$results
#' # Or as a plot
#' plot(counterfactual)
#' plot(counterfactual, labels = TRUE, nr.solutions = 10)
#'
#' # Explain another instance
#' counterfactual$explain(X[2,], target = target)
#' plot(counterfactual)
#' 
#' # Counterfactuals() can only focus on one class, not multiple 
#' # classes at a time
#' rf = randomForest(Species ~ ., data = iris)
#' X = iris[-which(names(iris) == "Species")]
#' mod = Predictor$new(rf, data = X, type = "prob", class = "setosa")
#'
#' # Then we explain the prediciton of the first instance
#' counterfactuals = Counterfactuals$new(mod, x.interest = X[1,], target = 0, 
#' generations = 10)
#' counterfactuals$results
#' plot(counterfactuals) 
#' }
NULL


#'@export
Counterfactuals = R6::R6Class("Counterfactuals", 
  inherit = InterpretationMethod,
  public = list(
    x.interest = NULL,
    y.hat.interest = NULL,
    target = NULL, 
    epsilon = NULL,
    fixed.features   = NULL,
    max.changed  = NULL,
    mu  = NULL,
    generations  = NULL,
    p.mut  = NULL,
    p.rec  = NULL,
    p.mut.gen  = NULL,
    p.mut.use.orig = NULL, 
    p.rec.gen  = NULL,
    p.rec.use.orig = NULL,
    k = NULL,
    weights = NULL, 
    use.ice.curve.var = NULL,
    crow.dist.version = NULL, 
    sd.for.init = NULL,
    track.infeas = NULL,
    lower = NULL,
    upper = NULL,
    log = NULL,
    initialize = function(predictor, x.interest = NULL, target = NULL, 
      epsilon = NULL, fixed.features = NULL, max.changed = NULL, 
      mu = 50, generations = 50, p.rec = 0.9, p.rec.gen = 0.7, p.rec.use.orig = 0.7,
      p.mut = 0.2, p.mut.gen = 0.5, p.mut.use.orig = 0.2, k = 1L, weights = NULL,
      use.ice.curve.var = FALSE,  
      lower = NULL, upper = NULL, crow.dist.version = 1, sd.for.init = FALSE, 
      track.infeas = TRUE) {
      
      super$initialize(predictor = predictor)
      fixed.features = private$sanitize_feature(fixed.features, predictor$data$feature.names)
      
      # can be missing
      checkmate::assert_data_frame(x.interest, null.ok = TRUE)
      checkmate::assert_numeric(target, null.ok = TRUE, min.len = 1, 
        max.len = 2, any.missing = FALSE)
      if (!is.null(target) && all(sapply(target, is.infinite))) {
        stop("One element of target must be finite")
      }
      checkmate::assert_number(epsilon, null.ok = TRUE)
      checkmate::assert_integerish(max.changed, null.ok = TRUE, len = 1)
      checkmate::assert_numeric(lower, null.ok = TRUE, any.missing = FALSE)
      checkmate::assert_numeric(upper, null.ok = TRUE, any.missing = FALSE)
      
      # should exist
      checkmate::assert_integerish(mu, lower = 1)
      assert(
        checkInt(generations, lower = 0),
        checkList(generations, types = "function")
      )
      checkmate::assert_number(p.mut, lower = 0, upper = 1)
      checkmate::assert_number(p.rec, lower = 0, upper = 1)
      checkmate::assert_number(p.mut.gen, lower = 0, upper = 1)
      checkmate::assert_number(p.rec.gen, lower = 0, upper = 1)
      checkmate::assert_number(p.mut.use.orig, lower = 0, upper = 1)
      checkmate::assert_number(p.rec.use.orig, lower = 0, upper = 1)
      checkmate::assert_integerish(k, lower = 1)
      checkmate::assert_numeric(weights, null.ok = TRUE, lower = 0, upper = 1, len = k)
      checkmate::assert_true(crow.dist.version %in% c(1, 2, 3))
      checkmate::assert_logical(use.ice.curve.var)
      checkmate::assert_logical(sd.for.init)
      checkmate::assert_logical(track.infeas)
      
      # assign
      self$target = target
      self$epsilon = epsilon
      self$max.changed = max.changed
      self$fixed.features = fixed.features
      self$mu = mu
      self$generations = generations
      self$p.mut = p.mut
      self$p.rec = p.rec 
      self$p.mut.gen = p.mut.gen
      self$p.mut.use.orig = p.mut.use.orig
      self$p.rec.gen = p.rec.gen
      self$p.rec.use.orig = p.rec.use.orig
      self$k = k
      self$use.ice.curve.var = use.ice.curve.var
      self$crow.dist.version = crow.dist.version
      self$lower = lower
      self$upper = upper
      self$sd.for.init = sd.for.init
      self$track.infeas = track.infeas
      
      # Define parameterset
      private$param.set= ParamHelpers::makeParamSet(
        params = make_paramlist(predictor$data$get.x(), 
          lower = lower, upper = upper))
      
      # Extract info from input.data
      private$range = ParamHelpers::getUpper(private$param.set) - 
        ParamHelpers::getLower(private$param.set)
      private$range[ParamHelpers::getParamIds(private$param.set)
        [ParamHelpers::getParamTypes(private$param.set) == "discrete"]]  = NA
      private$range = private$range[predictor$data$feature.names]
      private$sdev = apply(Filter(is.numeric, predictor$data$get.x()), 2, sd)
      
      # Set x.interest     
      if (!is.null(x.interest) & !is.null(target)) {
        private$set_x_interest(x.interest)
        private$run()
      }
      #cat("initialize finished\n")
    }, 
    explain = function(x.interest, target) {
      checkmate::assert_numeric(target, min.len = 1, 
        max.len = 2, any.missing = FALSE, null.ok = FALSE)
      if (all(sapply(target, is.infinite))) {
        stop("One element of target must be finite")
      }
      checkmate::assert_true
      self$target = target
      private$set_x_interest(x.interest)
      private$flush()
      private$run()
      return(self)
    },
    subset_results = function(nr.solutions = 10L) {
      cfexps = self$results$counterfactuals
      if (nr.solutions >= nrow(cfexps)) {
        warning("nr.solutions out of range, it was set to the number of solutions in self$results")
        return(cfexps)
      }
      assert_integerish(nr.solutions, lower = 1)
      ods = computeCrowdingDistanceR(fitness = t(cfexps[, private$obj.names]), 
        candidates = cfexps[, names(cfexps[, self$predictor$data$feature.names])])
      idx = order(ods, decreasing = TRUE)[1:nr.solutions]
      results.subset = self$results
      results.subset$counterfactuals = results.subset$counterfactuals[idx, ]
      rownames(results.subset$counterfactuals) = NULL
      results.subset$counterfactuals.diff = results.subset$counterfactuals.diff[idx,]
      rownames(results.subset$counterfactuals.diff) = NULL
      return(results.subset)
    },
    plot_statistics = function() {
      min.obj = c("generation", paste(private$obj.names, "min", sep = "."))    
      mean.obj = c("generation", paste(private$obj.names, "mean", sep = "."))
      eval = c("generation", "fitness.domHV") 
      nameList = list(min.obj, mean.obj, eval)
      log = self$log
      p = lapply(nameList, function(nam) {
        df = reshape2::melt(log[,nam] , id.vars = "generation", variable.name = "legend")
        singlep = ggplot(df, aes(generation, value)) + 
          geom_line(aes(colour = legend)) + 
          theme_bw() +
          ylab("value")
        return(singlep)
      })
      p
    },
    plot_search = function() {
      pf.over.gen = lapply(seq_len(nrow(self$log)), 
        FUN = function(i) {
          pf.gen = as.data.frame(t(private$ecrresults$log$env$pop[[i]]$fitness))
          names(pf.gen) = paste("y", 1:3, sep = "")
          pf.gen$generation = i-1
          pf.gen
        })
      
      pf.over.gen.df = do.call(rbind, pf.over.gen)
      
      pfPlot = ggplot(data = pf.over.gen.df, aes(x=y1, y=y2, alpha = generation)) +
        geom_point(col = "black")+
        theme_bw() +
        xlab(private$obj.names[1]) +
        ylab(private$obj.names[2])
      
      pfPlot
    },
    continue_search = function(generations) {
      private$ecrresults = continueEcr(ecr.object = private$ecrresults, generations = generations)
      results = mosmafs::listToDf(private$ecrresults$pareto.set, private$param.set)
      results[, grepl("use.orig", names(results))] = NULL
      private$dataDesign = results
      private$qResults = private$run.prediction(results)
      self$results = private$aggregate()    
    },
    calculate_hv = function() {
      return(tail(self$log$fitness.domHV, 1))
    }, 
    calculate_diversity = function() {
      return(tail(self$log$population.div, 1))
    }, 
    calculate_frequency = function(plot = FALSE, subset.zero = FALSE) {
      diff = self$results$counterfactuals.diff
      diff = diff[!(names(diff) %in% c(private$obj.names, "pred"))]
      freq = colSums(diff != 0)/nrow(diff)
      freq = freq[order(freq, decreasing = TRUE)]
      if (subset.zero) {
          freq = freq[which(freq != 0)]
      }
      if (plot) {
        barplot(freq, ylim = c(0, 1), ylab = "Relative frequency")
      }
      return(freq)
    }
  ), 
  private = list(
    featurenames = NULL,
    range = NULL,
    ref.point = NULL,
    sdev = NULL,
    param.set= NULL,
    param.set.init = NULL,
    ecrresults = NULL,
    obj.names = NULL, 
    set_x_interest = function(x.interest) {
      assert_data_frame(x.interest, any.missing = FALSE, all.missing = FALSE, 
        nrows = 1, null.ok = FALSE)
      if(any(!(self$predictor$data$feature.names %in% colnames(x.interest)))) {
        stop("colnames of x.interest must be identical to observed data")
      }
      x.interest = x.interest[setdiff(colnames(x.interest), self$predictor$data$y.names)]
      if (any(colnames(x.interest) != self$predictor$data$feature.names)) {
        warning("columns of x.interest were reordered according to predictor$data$feature.names")
        x.interest = x.interest[, self$predictor$data$feature.names]
      }
      x.interest.list = as.list(x.interest)
      x.interest.list$use.orig = rep(TRUE, ncol(x.interest))
      if (!ParamHelpers::isFeasible(private$param.set, x.interest.list)) {
        stop(paste("Feature values of x.interest outside range of observed data",
          "of predictor or given arguments lower or upper. Please modify arguments",
          "lower or upper accordingly."))
      }
      self$y.hat.interest = self$predictor$predict(x.interest)[1,]
      self$x.interest = x.interest
    }, 
    flush = function() {
      private$ecrresults = NULL
      self$results = NULL
      private$finished = FALSE
    },
    intervene = function() {
      
      # Define reference point for hypervolumn computation
      private$ref.point = c(min(abs(self$y.hat.interest - self$target)), 
        1, ncol(self$x.interest))
      if (self$track.infeas) {
        private$ref.point = c(private$ref.point, 1)
      }
      if (is.infinite(private$ref.point[1])) {
        pred = self$predictor$predict(self$predictor$data$get.x())
        private$ref.point[1] = diff(c(min(pred), max(pred)))
      }
      # Initialize population based on x.interest, param.set 
      # Use sd to initialize numeric features (default FALSE) 
      if (self$sd.for.init && length(private$sdev) > 0) {
          lower = self$x.interest[names(private$sdev)] - private$sdev
          upper = self$x.interest[names(private$sdev)] + private$sdev
          if (nrow(lower)>0 && nrow(upper)>0) {
            lower.ps = pmax(ParamHelpers::getLower(private$param.set), lower)
            upper.ps = pmin(ParamHelpers::getUpper(private$param.set), upper)
            lower.ps[names(self$lower)] = self$lower
            upper.ps[names(self$upper)] = self$upper
            private$param.set.init = ParamHelpers::makeParamSet(params = make_paramlist(
              self$predictor$data$get.x(), 
              lower = lower.ps, 
              upper = upper.ps))
            }
        } else {
          private$param.set.init = private$param.set
        }
      initial.pop = ParamHelpers::sampleValues(private$param.set.init, self$mu, 
        discrete.names = TRUE)
      
      # Use ice curve variance to initialize use.original vector
      if (self$use.ice.curve.var) {
        ice.var = get_ICE_var(self$x.interest, self$predictor, private$param.set)
        prob.use.orig = 1 - mlr::normalizeFeatures(as.data.frame(ice.var), 
          method = "range", range = c(0.01, 0.99))
        ilen = length(initial.pop[[1]]$use.orig)
        distribution = function() rbinom(n = ilen, size = ilen, 
          prob = t(prob.use.orig))
        initial.pop = initSelector(initial.pop, vector.name = "use.orig", 
          distribution = distribution)
      }
      
      i = sapply(self$x.interest, is.factor)
      x.interest = self$x.interest
      x.interest[i] = lapply(self$x.interest[i], as.character)
      
      initial.pop = lapply(initial.pop, function(x) {
        x = transform_to_orig(x, x.interest, delete.use.orig = FALSE, 
          fixed.features = self$fixed.features, max.changed = self$max.changed)
      })
      
      # Create fitness function with package smoof
      n.objectives = ifelse(self$track.infeas, 4, 3)
      
      fn = smoof::makeMultiObjectiveFunction(
        has.simple.signature = FALSE, par.set = private$param.set, 
        n.objectives = n.objectives, 
        noisy = TRUE, ref.point = private$ref.point,
        fn = function(x, fidelity = NULL) {
          fitness_fun(x, x.interest = self$x.interest, target = self$target, 
            predictor = self$predictor, train.data = self$predictor$data$get.x(), 
            range = private$range, track.infeas = self$track.infeas, 
            k = self$k, weights = self$weights)
        })
      
      fn = mosmafs::setMosmafsVectorized(fn)
      
      # Define operators based on parameterset private$param.set
      # Messages can be ignored
      sdev.l = sdev_to_list(private$sdev, private$param.set)
      # Use mutator based on conditional distributions if functions are given 
      # it is the case if self$predictor$conditional is NOT logical
      if (is.logical(self$predictor$conditional)) {
        single.mutator = suppressMessages(mosmafs::combine.operators(private$param.set,
          numeric = ecr::setup(mosmafs::mutGaussScaled, p = self$p.mut.gen, sdev = sdev.l$numeric),
          integer = ecr::setup(mosmafs::mutGaussIntScaled, p = self$p.mut.gen, sdev = sdev.l$integer),
          discrete = ecr::setup(mosmafs::mutRandomChoice, p = self$p.mut.gen),
          logical = ecr::setup(ecr::mutBitflip, p = self$p.mut.gen),
          use.orig = ecr::setup(mosmafs::mutBitflipCHW, p = self$p.mut.use.orig),
          .binary.discrete.as.logical = TRUE))
        mutator = ecr::makeMutator(function(ind) {
          transform_to_orig(single.mutator(ind), x.interest, delete.use.orig = FALSE,
            fixed.features = self$fixed.features, max.changed = self$max.changed)
        }, supported = "custom")
      } else {
        single.mutator = suppressMessages(mosmafs::combine.operators(private$param.set,
          numeric = ecr::setup(mosmafs::mutGaussScaled, p = self$p.mut.gen, sdev = sdev.l$numeric),
          integer = ecr::setup(mosmafs::mutGaussIntScaled, p = self$p.mut.gen, sdev = sdev.l$integer),
          discrete = ecr::setup(mosmafs::mutRandomChoice, p = self$p.mut.gen),
          logical = ecr::setup(ecr::mutBitflip, p = self$p.mut.gen),
          use.orig = ecr::setup(mosmafs::mutBitflipCHW, p = self$p.mut.use.orig),
          .binary.discrete.as.logical = TRUE))
        
        mutator = ecr::makeMutator(function(ind) {
          # Transform use.original 
          ind$use.orig = as.logical(mosmafs::mutBitflipCHW(as.integer(ind$use.orig), p = self$p.mut.use.orig))
          # Transform to original values
          ind = transform_to_orig(single.mutator(ind), x.interest, delete.use.orig = FALSE,
            fixed.features = self$fixed.features, max.changed = self$max.changed)
          ind.short = ind
          ind.short$use.orig = NULL
          # Select features to mutate: 
          affect = NA
          affect = runif(length(ind.short)) < self$p.mut.gen
          cols.nams = names(ind)[names(ind)!="use.orig"]
          affected.cols = cols.nams[affect & !ind$use.orig]
          # Shuffly mutation order
          affected.cols = sample(affected.cols)
          if (length(affected.cols != 0)) {
            for (a in affected.cols) {
              X = data.table::as.data.table(data.frame(ind.short, stringsAsFactors = FALSE))
              single.mutator = suppressMessages(mosmafs::combine.operators(private$param.set,
                .params.group = c(a), 
                group = ecr::setup(mutConDens, X = X, 
                  pred = self$predictor, param.set = private$param.set), 
                use.orig = mutInd, numeric = mutInd, integer = mutInd, discrete = mutInd,
                logical = mutInd, .binary.discrete.as.logical = FALSE))
              ind = single.mutator(ind)
            }
          }
          return(ind)
        }, supported = "custom")
      }
      
      recombinator = suppressMessages(mosmafs::combine.operators(private$param.set,
        numeric = ecr::setup(ecr::recSBX, p = self$p.rec.gen),
        integer = ecr::setup(mosmafs::recIntSBX, p = self$p.rec.gen),
        discrete = ecr::setup(mosmafs::recPCrossover, p = self$p.rec.gen),
        logical = ecr::setup(mosmafs::recPCrossover, p = self$p.rec.gen),
        use.orig = ecr::setup(mosmafs::recPCrossover, p = self$p.rec.use.orig),
        .binary.discrete.as.logical = TRUE))
      
      overall.recombinator <- ecr::makeRecombinator(function(inds, ...) {
        inds <- recombinator(inds)
        do.call(ecr::wrapChildren, lapply(inds, function(x) { 
          transform_to_orig(x, x.interest, delete.use.orig = FALSE, 
            fixed.features = self$fixed.features, max.changed = self$max.changed) 
        }))
      }, n.parents = 2, n.children = 2)
      
      parent.selector = mosmafs::selTournamentMO
    
      
      survival.selector = ecr::setup(select_nondom, 
        epsilon = self$epsilon,  
        extract.duplicates = TRUE, vers = self$crow.dist.version)
      
      # Extract algorithm information with a log object
      # Calculate hypervolume
      log.stats = list(fitness = lapply(
        seq_len(n.objectives), 
        function(idx) {
          list(min = function(x) min(x[idx, ]), mean = function(x) mean(x[idx, ]))
        }))
      names(log.stats$fitness) = sprintf("obj.%s", seq_len(n.objectives))
      log.stats$fitness = unlist(log.stats$fitness, recursive = FALSE)
      log.stats$fitness = c(log.stats$fitness,
        list(domHV = function(x) ecr::computeHV(x,
          ref.point = private$ref.point), 
          n.row = function(x) sum(ecr::nondominated(x))
        ))
      
      # Compute counterfactuals
      ecrresults = mosmafs::slickEcr(fn, lambda = self$mu, population = initial.pop,
        mutator = mutator,
        recombinator = overall.recombinator, generations = self$generations,
        parent.selector = parent.selector,
        survival.strategy = select_diverse,
        survival.selector = survival.selector,
        p.recomb = self$p.rec,
        p.mut = self$p.mut, log.stats = log.stats)
      
      private$ecrresults = ecrresults
      results = mosmafs::listToDf(ecrresults$pareto.set, private$param.set)
      results[, grepl("use.orig", names(results))] = NULL
      return(results)
    },
    aggregate = function() {
      
      pareto.front = private$ecrresults$pareto.front
      if (self$track.infeas) {
        private$obj.names = c("dist.target", "dist.x.interest", "nr.changed", "dist.train")
        id.cols = 9
      } else {
        private$obj.names = c("dist.target", "dist.x.interest", "nr.changed")
        id.cols = 7
      }
      names(pareto.front) = private$obj.names
      
      pareto.set = private$dataDesign
      
      pareto.set.diff = get_diff(pareto.set, self$x.interest)
      pred = private$qResults
      names(pred) = "pred"
      
      pareto.set.pf = cbind(pareto.set, pred, pareto.front)
      pareto.set.pf = pareto.set.pf[order(pareto.set.pf$dist.target, pareto.set.pf$nr.changed, 
          pareto.set.pf$dist.x.interest),]
      rownames(pareto.set.pf) = NULL
      pareto.set.diff.pf = cbind(pareto.set.diff, pred, pareto.front) 
      pareto.set.diff.pf = pareto.set.diff.pf[order(pareto.set.diff.pf$dist.target, pareto.set.diff.pf$nr.changed, 
          pareto.set.diff.pf$dist.x.interest),]
      rownames(pareto.set.diff.pf) = NULL
      
      results = list()
      results$counterfactuals = pareto.set.pf
      results$counterfactuals.diff = pareto.set.diff.pf
      
      # Add diversity to log data frame
      pop = mosmafs::getPopulations(private$ecrresults$log)
      div = unlist(lapply(pop, 
        FUN = function(x) {
          pop_gen = mosmafs::listToDf(x$population, private$param.set)
          pop_gen[, grepl("use.orig", names(pop_gen))] = NULL
          compute_diversity(pop_gen, private$range)
        }))
      log = mosmafs::getStatistics(private$ecrresults$log)
      log$population.div = div
      sum.nam = paste(rep(private$obj.names, each = 2), 
        c("min", "mean"), sep = ".")
      nam = c("generation", sum.nam)
      names(log)[1:id.cols] = nam
      evals = mosmafs::collectResult(private$ecrresults)$evals
      log$evals = evals
      
      log = log[c("generation", "state", "evals", nam[2:id.cols], "fitness.domHV", 
        "population.div", "fitness.n.row")]
      self$log = log
      
      #cat("aggregate finished\n")
      return(results)
    },
    generatePlot = function(labels = FALSE, decimal.points = 3, nr.solutions = NULL, 
      nr.changed = NULL) {
      assert_logical(labels)
      assert_integerish(decimal.points, null.ok = !labels)
      assert_int(nr.solutions, null.ok = TRUE)
      assert_integerish(nr.changed, null.ok = TRUE)
      results_diff = self$results$counterfactuals.diff
      if (!is.null(nr.solutions)) {
        results_diff = self$subset_results(nr.solutions)$counterfactuals.diff
      }
      if (!is.null(nr.changed)) {
        results_diff = results_diff[results_diff$nr.changed %in% nr.changed, ]
      }
      pf = results_diff[, private$obj.names]
      
      p = ggplot(data = pf, aes(x=dist.target, y=dist.x.interest, 
        color = as.factor(nr.changed))) +
        geom_point() +
        xlab("dist target") +
        ylab("dist x.interest") +
        theme_bw() +
        guides(color=guide_legend(title="nr changed"))
      
      if (labels) {
        diffs = results_diff[, !(names(results_diff) %in% c(private$obj.names, "pred", "X1"))]
        labels = c()
        for(i in 1:nrow(diffs)) {
          names = names(diffs[i,])[diffs[i,] != 0]
          lab = as.data.frame(diffs[i, names])
          lab = paste(paste(names, round_df(lab, decimal.points)), collapse = " & ")
          labels = c(labels, lab)
        }
        p = p + ggrepel::geom_label_repel(aes(label = labels),
          box.padding   = 0.35, 
          point.padding = 0.4, 
          show.legend = FALSE) 
      }
      p
    },
    sanitize_feature = function(fixed.features, feature.names) {
      if (is.numeric(fixed.features)) {
        assert_integerish(fixed.features, lower = 1, upper = length(feature.names), 
          null.ok = TRUE)
        fixed.features = feature.names[fixed.features]
      }
      assert_character(fixed.features, null.ok = TRUE, unique = TRUE)
      stopifnot(all(fixed.features %in% feature.names))
      fixed.features
    }
  ))


#' Plot Counterfactuals
#'
#' \code{plot.Counterfactuals()} plots the Pareto front in 2-D of the found Counterfactuals.
#' The x-axis displays the distance of the prediction to the desired prediction. 
#' The y-axis displays the distance of the counterfactual to the original datapoint x.interest. 
#' The colouring displays how many features were changed.
#' 
#' @format \code{\link{R6Class}} object.
#' @section Arguments:
#' \describe{
#' \item{labels:}{logical(1)\cr Whether labels with difference to feature values of 
#' x.interest should be plotted. Default is FALSE.}
#' \item{decimal.points:}{integer(1)\cr Number of decimal places used. Default is 3.}
#' \item{nr.solutions:}{integer(1)\cr Number of solutions showed. Default NULL means, 
#' all solutions are showed.}
#' \item{nr.changed:}{integer(1)\cr Plot only counterfactuals with certain number of 
#' changed features. Default is NULL.}
#' }
#' @return ggplot2 plot object
#' @seealso 
#' \link{Counterfactuals}
#' @examples 
#' \dontrun{
#' if (require("randomForest")) {
#' data("Boston", package  = "MASS")
#' Boston = Boston
#' set.seed(1000)
#' rf =  randomForest(medv ~ ., data = Boston)
#' X = Boston[-which(names(Boston) == "medv")]
#' mod = Predictor$new(rf, data = X)
#' 
#' # Then we calculate Counterfactuals for the first instance
#' x.interest = X[1,]
#' mod$predict(x.interest)
#' target = 30
#' cf = Counterfactuals$new(mod, x.interest = x.interest, target = target, 
#'   mu = 50, generations = 60)
#'
#' # The results can be plotted
#' plot(cf)
#' plot(cf, labels = TRUE, nr.solutions = 10)
#' }
#' }
#' @export
plot.Counterfactuals = function(object, labels = FALSE, decimal.points = 3, nr.solutions = NULL, nr.changed = NULL) {
  object$plot(labels = labels, decimal.points = decimal.points, nr.solutions = nr.solutions, 
    nr.changed = nr.changed)
}

#' @title Calculate frequency of altered features in final solution set 
#'  
#' @description Identify leverages that alter prediction to desired target
#'  over multiple datapoints. Leverages are identified by calculating
#'  the frequency a feature was altered within the set of the 
#'  final calculated counterfactuals.  
#'  
#' @section Arguments: 
#' \describe{
#' \item{counterfactual: }{(Counterfactuals)\cr Instance of class 
#' Counterfactual to extract
#' dataset and target, if not needed, as well as all the parameters}
#' \item{target: }{(numeric(1)|numeric(2))\cr Desired outcome either a 
#' single numeric or 
#' a vector of two numerics, to define a desired interval of outcome.}
#' \item{obs: }{(data.frame) Data frame to use to identify leverages 
#' by calculating counterfactuals for them}
#' \item{row.ids }{(integer) Rows with the specific row.ids are extracted
#' from the input data defined in the predictor field of the 
#' Counterfactuals class. The subset is used to identify leverages.}
#' \item{plot: }{(logical(1)) Whether to plot the frequency over all 
#' observations}
#' }
#' 
#' @export
calculate_frequency_wrapper = function(counterfactual, target = NULL, obs = NULL, 
  row.ids = NULL, plot = FALSE) {
  assert_data_frame(obs, null.ok = TRUE)
  assert_integerish(row.ids, null.ok = TRUE)
  assert_numeric(target, min.len = 1, max.len = 2, null.ok = TRUE)
  if (is.null(counterfactual$target) & is.null(target)) {
    stop("target not specified")
  }
  
  df = counterfactual$predictor$data$get.x()
  if (!is.null(obs)) {
    df = obs
  }
  if (!is.null(row.ids)) {
    df = df[row.ids,]
  }
  if(is.null(target)) {
    target = counterfactual$target 
  }
  
  df = as.data.frame(df)
  freq = by(df, 1:nrow(df), function(row) {
    counterfactual = counterfactual$explain(row, target)
    counterfactual$calculate_frequency()
  })
  freq = do.call(rbind, freq)
  
  average_freq = colMeans(freq)
  
  if(plot) {
    barplot(average_freq, ylim = c(0, 1), ylab = "Relative frequency")
  }
  return(average_freq)
  
}


