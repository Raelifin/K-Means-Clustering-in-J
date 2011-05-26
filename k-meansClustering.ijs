NB. UTILITIES!
randMatrix =: ($ ?) (*/ # 0:) NB. y=shape
distSquared =: ([: +/ [: *: -)"1 1
indexOfMin =: (i. <./)"1
load 'trig'
convertToEuclid =: (((0&{)*(cos@:o.@:+:@:(1&{))) , ((0&{)*(sin@:o.@:+:@:(1&{))))"1 NB. y=2d polar coords

NB. CONSTANTS!
dimensionality =: 2
datasetSize =: 1000
NB. Use the following line for a circular (polar) distribution
dataset =: convertToEuclid randMatrix datasetSize, dimensionality
NB. Use the following line for a square distribution
NB. dataset =: randMatrix datasetSize, dimensionality

meansCount =: 5

NB. CLUSTERING FUNCTIONS!
indexesOfClosestMean =: [: indexOfMin distSquared/ NB. x=dataset, y=means
nextMeans =: indexesOfClosestMean (+/ % #)/. [ NB. x=dataset, y=means

NB. INITIAL STATE!
randomIndexGivenWeights =: ([: (* ?@:0:) +/) ((< +/\) i. 1:) ]
distancesToNearestCenter =: [: (<./)"1 distSquared/ NB. x=dataset, y=means
randomWeightedDatapoint =: randomIndexGivenWeights@:distancesToNearestCenter { [ NB. x=dataset, y=means

firstMean =: ((1 ? #) { ]) dataset

appendNewMean =: ] , (dataset randomWeightedDatapoint ])

initMeans =: appendNewMean^:(meansCount-1) firstMean
NB. The above uses k-means++. If you want a simple random inital pick (Lloyd's algorithm) use:
NB. initMeans =: randMatrix meansCount, 2
NB. This random matrix may have to be scaled if the dataset is not in (0,1)

NB. RESULTS!
finalMeans =: dataset nextMeans^:_ initMeans
finalPartitions =: dataset (indexesOfClosestMean </. [) finalMeans

NB. GRAPHICS!
load 'plot'

projectOntoPlane =: (0 1&{)"1
packPoints =: [: <"1 |: NB. y=list of tuples to graph
graph =: pd@:packPoints@:projectOntoPlane

pd 'reset;aspect 1'

pd 'type dot;pensize 2'
dataset (indexesOfClosestMean graph/. [) finalMeans

pd 'type marker;markersize 1.5;color 0 0 0'
graph finalMeans
pd 'markersize 0.8;color 255 255 0'
graph finalMeans

pd 'show'