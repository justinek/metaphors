var relationOrders = [['f', 'p', 'h']];
                      
var arrowOrders = [[1, 1, 1], [1, 1, 0], [1, 0, 1], [1, 0, 0],
                   [0, 1, 1], [0, 1, 0], [0, 0, 1], [0, 0, 0]];

var indices = [[0, 1], [0, 2], [1, 2]];

matrixArray = [];

for (var a=0; a < arrowOrders.length; a++) {
    for (var r=0; r < relationOrders.length; r++) {
        matrix = []
        for ( var i = 0; i < 3; i++ ) {
            matrix[i] = [0, 0, 0]; 
        }
        for (var j = 0; j < 3; j++) {
            if (arrowOrders[a][j] == 1) {
                var index1 = indices[j][0];
                var index2 = indices[j][1];
            } else {
                var index1 = indices[j][1];
                var index2 = indices[j][0];
            }
            matrix[index1][index2] = relationOrders[r][j];
        }
        matrixArray.push(matrix);
    }
}

//matrixArray


var targetOrders = [["immune system", "virus", "body"],
                    ["immune system", "body", "virus"],
                    ["virus", "immune system", "body"],
                    ["virus", "body", "immune system"],
                    ["body", "immune system", "virus"],
                    ["body", "virus", "immune system"]];
        
var sourceOrders = [["army", "enemy", "country"],
                    ["army", "country", "enemy"],
                    ["enemy", "army", "country"],
                    ["enemy", "country", "army"],
                    ["country", "enemy", "army"],
                    ["country", "army", "enemy"]];
                    

                    
var makeOrderedGraphs = function(matrices, orders) {
    var orderedGraphs = [];
    for (var m=0; m < matrices.length; m++) {
        for (var o=0; o < orders.length; o++) {
            var og = [matrices[m],orders[o]];
            orderedGraphs.push(og);
        }
    }
    return orderedGraphs;
}

var targetOrderedGraphs = makeOrderedGraphs(matrixArray, targetOrders);
var sourceOrderedGraphs = makeOrderedGraphs(matrixArray, sourceOrders);
var atomOrderedGraphs = makeOrderedGraphs(orbitGraphs, atomOrders);
var solarOrderedGraphs = makeOrderedGraphs(orbitGraphs, solarOrders);
var printGraphs = function(graphs) {
    for (var t=0; t < graphs.length; t++) {
        console.log('[');
        console.log(graphs[t][0]);
        console.log(',');
        console.log(graphs[t][1]);
        console.log('],');
    }
}

var makePriors = function(graphs, category) {
    var probs = [];
    for (var i=0; i < graphs.length; i++) {
        var thisGraph = graphs[i];
        var structure = thisGraph[0];
        var ordering = thisGraph[1];
        if (category=="army") {
            var iArmy = ordering.indexOf("army");
            var iEnemy = ordering.indexOf("enemy");
            var iCountry = ordering.indexOf("country");
            //console.log(thisGraph);
            //console.log(iArmy);
            if (structure[iArmy][iEnemy]=='f' && structure[iArmy][iCountry]=='p' && structure[iEnemy][iCountry]=='h') {
                probs.push(1);
            } else {
                probs.push(0);
            }
        } else if (category=="immune system") {
            var iImmune = ordering.indexOf("immune system");
            var iVirus = ordering.indexOf("virus");
            var iBody = ordering.indexOf("body");
            if (structure[iVirus][iBody]=='h') {
                probs.push(1);
            } else {
                probs.push(0);
            }
        }
    }
    return probs;
}
printGraphs(atomOrderedGraphs)
//printGraphs(solarOrderedGraphs)
//sourceOrderedGraphs.length
//console.log(makeOrderedGraphs(matrixArray, targetOrders))
//console.log(matrixArray);
//var sourcePriors = makePriors(sourceOrderedGraphs, "army");
//var targetPriors = makePriors(targetOrderedGraphs, "immune system");
//console.log(sourcePriors)
//console.log(targetPriors)                    
             
    