function showSlide(id) {
  $(".slide").hide();
  $("#"+id).show();
}

function random(a,b) {
  if (typeof b == "undefined") {
    a = a || 2;
    return Math.floor(Math.random()*a);
  } else {
    return Math.floor(Math.random()*(b-a+1)) + a;
  }
}

function shuffle(array) {
  var currentIndex = array.length
    , temporaryValue
    , randomIndex
    ;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}

function repeatArray(array, numRepeat) {
  for (i=1; i < numRepeat; i++) {
    array = array.concat(array);
  }
  return array;
}

Array.prototype.random = function() {
  return this[random(this.length)];
}

function setQuestion(array) {
    var i = random(0, array.length - 1);
    var q = array[i];
    return q;
}

function shuffledArray(arrLength)
{
  var j, tmp;
  var arr = new Array(arrLength);
  for (i = 0; i < arrLength; i++)
  {
    arr[i] = i;
  }
  for (i = 0; i < arrLength-1; i++)
  {
    j = Math.floor((Math.random() * (arrLength - 1 - i)) + 0.99) + i;
    tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
  return arr;
}

function getRadioCheckedValue(formNum, radio_name)
{
   var oRadio = document.forms[formNum].elements[radio_name];
   for(var i = 0; i < oRadio.length; i++)
   {
      if(oRadio[i].checked)
      {
         return oRadio[i].value;
      }
   }
   return '';
}

function clearForm(oForm) {
    
  var elements = oForm.elements; 
    
  oForm.reset();

  for(i=0; i<elements.length; i++) {
      
	field_type = elements[i].type.toLowerCase();
	
	switch(field_type) {
	
		case "text": 
		case "password": 
		case "textarea":
	        case "hidden":	
			
			elements[i].value = ""; 
			break;
        
		case "radio":
		case "checkbox":
  			if (elements[i].checked) {
   				elements[i].checked = false; 
			}
			break;

		case "select-one":
		case "select-multi":
            		elements[i].selectedIndex = -1;
			break;

		default: 
			break;
	}
    }
}


var allConditions = 
[
[
{"item": "giraffe", "dimension": "height", "det": "a", "question": "How tall do you think the giraffe is", "answer": "The giraffe is", "unit": "feet tall"},
{"item": "hamster", "dimension": "height", "det": "a",  "question": "How tall do you think the hamster is", "answer": "The hamster is", "unit": "feet tall"},
{"item": "cheetah", "dimension": "speed", "det": "a", "question": "How fast do you think the cheetah can run", "answer": "The cheetah can run at", "unit": "mile(s) per hour"},
{"item": "turtle", "dimension": "speed", "det": "a", "question": "How fast do you think the turtle can run", "answer": "The turtle can run at", "unit": "mile(s) per hour"},
{"item": "elephant", "dimension": "weight", "det": "an", "question": "How much do you think the elephant weighs", "answer": "The elephant weighs", "unit": "pound(s)"},
{"item": "bird", "dimension": "weight", "det": "a", "question": "How much do you think the bird weighs", "answer": "The bird weighs", "unit": "pound(s)"},
{"item": "man", "dimension": "height", "det": "a", "question": "How tall do you think the man is", "answer": "The man is", "unit": "feet tall"},
{"item": "man", "dimension": "speed", "det": "a", "question": "How fast do you think the man can run", "answer": "The man can run at", "unit": "mile(s) per hour"},
{"item": "man", "dimension": "weight", "det": "a", "question": "How much do you think the man weighs", "answer": "The man weighs", "unit": "pound(s)"},
{"item": "woman", "dimension": "height", "det": "a", "question": "How tall do you think the woman is", "answer": "The woman is", "unit": "feet tall"},
{"item": "woman", "dimension": "speed", "det": "a", "question": "How fast do you think the woman can run", "answer": "The woman can run at", "unit": "mile(s) per hour"},
{"item": "woman", "dimension": "weight", "det": "a", "question": "How much do you think the woman weighs", "answer": "The woman weighs", "unit": "pound(s)"},

]
];



var numConditions = allConditions.length;
var chooseCondition = random(0, numConditions-1);
var shuffledTrials = shuffle(allConditions[chooseCondition]);
var numTrials = shuffledTrials.length;

var currentTrialNum = 0;
var trial;
var numComplete = 0;

showSlide("instructions");
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);


var experiment = {
	
    responses: new Array(numTrials),
    orders: new Array(numTrials),
    items: new Array(numTrials),
    dimensions: new Array(numTrials),
    gender: "",
    age:"",
    income:"",
    nativeLanguage:"",
    comments:"",
    description: function() {
    	
    	showSlide("description");
    	$("#tot-num").html(numTrials);
    	
    },
    end: function() {
        var gen = getRadioCheckedValue(1, "genderButton");
        var ag = document.age.ageRange.value;
        var lan = document.language.nativeLanguage.value;
        var comm = document.comments.input.value;
        var incomeVal = document.income.incomeRange.value;
        experiment.gender = gen;
        experiment.age = ag;
        experiment.nativeLanguage = lan;
        experiment.comments = comm;
        experiment.income = incomeVal;
        clearForm(document.forms[1]);
        clearForm(document.forms[2]);
        clearForm(document.forms[3]);
        clearForm(document.forms[4]);
        clearForm(document.forms[5]);
        
        showSlide("finished");
        setTimeout(function() {turk.submit(experiment) }, 1500);
    },
    next: function() {
    	if (numComplete > 0) {
    		
    		  var response = parseFloat(document.response.score.value);
        	experiment.responses[currentTrialNum] = response;
        	experiment.orders[currentTrialNum] = numComplete;
        	
        	
        	experiment.items[currentTrialNum] = trial.item;
        
        	experiment.dimensions[currentTrialNum] = trial.dimension;
        	
        	clearForm(document.forms[0]);
        
        }
    	if (numComplete >= numTrials) {
    		$('.bar').css('width', (200.0 * numComplete/numTrials) + 'px');
    		$("#trial-num").html(numComplete);
    		$("#total-num").html(numTrials);
    		showSlide("askInfo");
    	} else {
    		$('.bar').css('width', (200.0 * numComplete/numTrials) + 'px');
    		$("#trial-num").html(numComplete);
    		$("#total-num").html(numTrials);
    		currentTrialNum = numComplete;

    		trial = shuffledTrials[numComplete];
    		
        showSlide("stage");
        $("#answer").html(trial.answer);
        $("#det").html(trial.det);
        $("#item").html(trial.item);
        $("#question").html(trial.question);
        $("#unit").html(trial.unit);
        numComplete++;
      }
    }
}


