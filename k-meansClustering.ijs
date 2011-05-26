NB. UTILITIES!
randMatrix =: ($ ?) (*/ # 0:) NB. y=shape
distSquared =: ([: +/ [: *: -)"1 1
indexOfMin =: (i. <./)"1
convertToEuclid =: (((0&{)*(cos@:o.@:+:@:(1&{))) , ((0&{)*(sin@:o.@:+:@:(1&{))))"1 NB. y=2d polar coords

NB. CONSTANTS!
dimensionality =: 2
datasetSize =: 300
NB. Use the following line if you want a circular (polar) distribution, rather than a square one
NB. dataset =: convertToEuclid randMatrix datasetSize, dimensionality
dataset =: randMatrix datasetSize, dimensionality

meansCount =: 3

NB. CLUSTERING FUNCTIONS!
indexesOfClosestMean =: [: indexOfMin distSquared/ NB. x=dataset, y=means
classes =: indexesOfClosestMean </. [ NB. x=dataset, y=means

means =: (+/ % #)@> NB. y=classes
nextClasses =: dataset classes means NB. y=classes

NB. INITIAL STATE!
randomIndexGivenWeights =: ([: (* ?@:0:) +/) ([: <./ 1 I.@E. (< +/\)) ]
weights =: [: (<./)"1 squareDistances
randomWeightedDatapoint =: ([: randomIndexGivenWeights weights) { dataset"_ NB. y=means

firstMean =: ((1 ? #) { ]) dataset

appendNextMean =: ] , randomWeightedDatapoint

initMeans =: appendNextMean^:(meansCount-1) firstMean
NB. The above uses k-means++. If you want a simple random inital pick (Lloyd's algorithm) use:
NB. initMeans =: randMatrix meansCount, 2
NB. This random matrix may have to be scaled if the dataset is not in (0,1)

NB. RESULTS!
finalClasses =: nextClasses^:_ (dataset classes initMeans)
finalMeans =: means finalClasses

NB. GRAPHICS!
projectOntoPlane =: (0 1&{)"1
packPoints =: [: <"1 |: NB. y=list of tuples to graph

load 'plot'
pd 'reset'
pd 'aspect 1'

pd 'type dot;pensize 2'
(pd@:packPoints@:projectOntoPlane@:>)"0 finalClasses

pd 'type marker;markersize 1.5;color 0 0 0'
pd packPoints projectOntoPlane finalMeans
pd 'markersize 0.8;color 255 255 0'
pd packPoints projectOntoPlane finalMeans

pd 'show'
