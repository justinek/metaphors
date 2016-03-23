// Javascript code goes here

var exampleJavascriptFn = function(x) {
  return x + 1;
}

var makeLabeledGraphs = function(indices, arrowOrders, relationOrders) {
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
	return matrixArray;
}

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

module.exports = {
  // Adjust exports here
  exampleJavascriptFn: exampleJavascriptFn,
  makeLabeledGraphs: makeLabeledGraphs,
  makeOrderedGraphs: makeOrderedGraphs,
  makePriors: makePriors
}