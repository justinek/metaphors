var makePairwiseRelations = function() {
	relations = [];
	for (var index1=0; index1 < 3; index1++) {
	    for (var index2=0; index2 < 3; index2++) {
	        for (var index3=0; index3 < 3; index3++) {
	            var arr=[]
	            arr[0] = index1;
	            arr[1] = index2;
	            arr[2] = index3;
	            relations.push(arr);
	        }
	    }
	}
	matrixArray = [];

	for (var i=0; i < relations.length; i++) {
	    matrix = []
	    for ( var j = 0; j < 3; j++ ) {
	        matrix[j] = [0, 0, 0]; 
	    }
	    var AB = relations[i][0];
	    var AC = relations[i][1];
	    var BC = relations[i][2];
	    if (AB==1) {
	        matrix[0][1] = 1
	    } else if (AB==2) {
	        matrix[1][0] = 1
	    }
	    if (AC==1) {
	        matrix[0][2] = 1
	    } else if (AC==2) {
	        matrix[2][0] = 1
	    }
	    if (BC==1) {
	        matrix[1][2] = 1
	    } else if (BC==2) {
	        matrix[2][1] = 1
	    }
	    matrixArray.push(matrix)
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
        if (category=="solar system") {
            var iSun = ordering.indexOf("sun");
            var iP1 = ordering.indexOf("p1");
            var iP2 = ordering.indexOf("p2");
            //console.log(thisGraph);
            //console.log(iArmy);
            if (structure[iP1][iSun]==1 && structure[iP2][iSun] == 1 &&
                structure[iP1][iP2]==0 && structure[iP2][iP1]==0) {
                probs.push(1);
            } else {
                probs.push(0);
            }
        } else if (category=="atom") {
            probs.push(0.1);
        }
    }
    return probs;
}


module.exports = {
  // Adjust exports here
  makePairwiseRelations: makePairwiseRelations,
  makeOrderedGraphs: makeOrderedGraphs,
  makePriors: makePriors,

}