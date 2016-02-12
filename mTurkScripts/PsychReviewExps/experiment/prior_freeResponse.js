var NUM_SLIDERS = 10;

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

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

function clearForm(oForm) {
  
  
  var elements = oForm.elements; 
  
  oForm.reset();

  for(var i=0; i<elements.length; i++) {
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

Array.prototype.random = function() {
  return this[random(this.length)];
}

function setQuestion(array) {
    var i = random(0, array.length - 1);
    var q = array[i];
    return q;
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

function shuffledSampleArray(arrLength, sampleLength)
{
  var arr = shuffledArray(arrLength);
  var beginIndex = Math.floor(Math.random() * (arrLength-sampleLength+1));
  return arr.slice(beginIndex, beginIndex+sampleLength);
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

function randomizeSharpOffset()
{
  
  var r = Math.floor((Math.random()*6)+1);
  if (r < 4) { return r; }
  else { return 3-r; }
  /*
  var r = Math.floor((Math.random()*3)+1);
  return r;
  */
}

var allConditions = 
[
[
{"dimension": "height", "dim": "tall", "item": "giraffe", "det": "a", "question": ["What is the ", "'s height?"], "unit": ["feet", "inches"], "bins": [1, 4, 4.5, 5, 5.5, 6, 6.5, 7, 15]},
{"dimension": "speed", "dim": "fast", "item": "cheetah", "det": "a", "question": ["How many miles can the ", " run in an hour?"], "unit": "miles per hour", "bins": [1, 5, 6, 7, 8, 9, 10, 20, 60]},
{"dimension": "weight", "dim": "heavy", "item": "elephant", "det": "an", "question": ["How much does the ", " weigh?"], "unit": "pounds", "bins": [10, 100, 120, 140, 160, 180, 200, 220, 10000]},
{"dimension": "height", "dim": "tall", "item": "penguin", "det": "a", "question": ["What is the ", "'s height?"], "unit": ["feet", "inches"], "bins": [1, 4, 4.5, 5, 5.5, 6, 6.5, 7, 15]},
{"dimension": "speed", "dim": "fast", "item": "turtle", "det": "a", "question": ["How many miles can the ", " run in an hour?"], "unit": "miles per hour", "bins": [1, 5, 6, 7, 8, 9, 10, 20, 60]},
{"dimension": "weight", "dim": "heavy", "item": "bird", "det": "an", "question": ["How much does the ", " weigh?"], "unit": "pounds", "bins": [10, 100, 120, 140, 160, 180, 200, 220, 10000]},
{"dimension": "height", "dim": "tall", "item": "man", "det": "a", "question": ["What is the ", "'s height?"], "unit": ["feet", "inches"], "bins": [1, 4, 4.5, 5, 5.5, 6, 6.5, 7, 15]},
{"dimension": "speed", "dim": "fast", "item": "man", "det": "a", "question": ["How many miles can the ", " run in an hour?"], "unit": "miles per hour", "bins": [1, 5, 6, 7, 8, 9, 10, 20, 60]},
{"dimension": "weight", "dim": "heavy", "item": "man", "det": "a", "question": ["How much does the ", " weigh?"], "unit": "pounds", "bins": [10, 100, 120, 140, 160, 180, 200, 220, 10000]},
{"dimension": "height", "dim": "tall", "item": "woman", "det": "a", "question": ["What is the ", "'s height?"], "unit": ["feet", "inches"], "bins": [1, 4, 4.5, 5, 5.5, 6, 6.5, 7, 15]},
{"dimension": "speed", "dim": "fast", "item": "woman", "det": "a", "question": ["How many miles can the ", " run in an hour?"], "unit": "miles per hour", "bins": [1, 5, 6, 7, 8, 9, 10, 20, 60]},
{"dimension": "weight", "dim": "heavy", "item": "woman", "det": "a", "question": ["How much does the ", " weigh?"], "unit": "pounds", "bins": [10, 100, 120, 140, 160, 180, 200, 220, 10000]},

]
];

/*var genders = shuffle(["woman", "woman", "woman", "man", "man", "man"]);
var responseTypes = shuffle(["lit", "lit", "lit", "fig", "fig", "fig"]);
var names_f = ["Amy", "Ann", "Cheryl", "Heather", "Rachel", "Nicole"];
var names_m = ["Joseph", "Mark", "Matthew", "Paul", "Derek", "Jeffrey"];
var names_all = shuffle(names_f.concat(names_m));
*/

var debug = false;
if(debug) { allConditions = debugConditions; }


var numConditions = allConditions.length;
var chooseCondition = random(0, numConditions-1);
var shuffledTrials = shuffle(allConditions[chooseCondition]);
var numTrials = shuffledTrials.length;

var currentTrialNum = 0;
var trial;
var numComplete = 0;
/*
var speaker;
var responseType;
var gender;
*/

repeatWorker = false;
  (function(){
      var ut_id = "jtk-sclmetint-3-20160125";
      if (UTWorkerLimitReached(ut_id)) {
        $('.slide').empty();
        repeatWorker = true;
        alert("You have already completed the maximum number of HITs allowed by this requester. Please click 'Return HIT' to avoid any impact on your approval rating.");
      }
  })();

showSlide("instructions");
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);


var experiment = {
	condition: chooseCondition + 1,
	
  orders: new Array(numTrials),
  items: new Array(numTrials),
  //desTypes: new Array(numTrials),
  //qualities: new Array(numTrials),
  dimensions: new Array(numTrials),
  //speakerGenders: new Array(numTrials),
  //describedGenders: new Array(numTrials),
  responses: new Array(numTrials),
  
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
      //var price = 0;//parseFloat(document.price.score.value) + parseFloat(document.price.score1.value) / 100.00;
      //experiment.priors10[currentTrialNum] = prob10;
      
      //experiment.desTypes[currentTrialNum] = responseType;
      //experiment.qualities[currentTrialNum] = trial.quality;
      
      experiment.orders[currentTrialNum] = numComplete;
      
      experiment.items[currentTrialNum] = trial.item;

      experiment.dimensions[currentTrialNum] = trial.dimension;

      //experiment.speakerGenders[currentTrialNum] = speaker;
      //experiment.describedGenders[currentTrialNum] = gender;
      if (trial.dim==="tall"){
        experiment.responses[currentTrialNum] = parseFloat(document.response.response1.value) * 12 + parseFloat(document.response.response2.value);
      } else {
        experiment.responses[currentTrialNum] = parseFloat(document.response.response.value);
      }
      clearForm(document.forms[0]);
      //clearForm(document.forms[1]);
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
/*
gender = genders[numComplete];
      var pronoun1;
      var pronoun2;
      var pronoun3;
      if (gender=="woman") {
        pronoun2 = "she";
        pronoun3 = "She";
      } else {
        pronoun2 = "he";
        pronoun3 = "He";
      }

      responseType = responseTypes[numComplete];
      var res = "hi";
      if (responseType == "lit") {
        if (trial.polarity=="high") {
          res = "Yes, " + pronoun2 + " is";
        } else {
          res = "No, " + pronoun2 + "'s not";
        }
      } else {
        res = pronoun3 + "'s " + trial.det + " " + trial.item;
      }

      var name = names_all[numComplete];
      if (names_f.indexOf(name) > -1) {
        pronoun1 = "her";
        speaker = "woman";
      } else {
        pronoun1 = "his";
        speaker = "man";
      }
*/
        //$("#answer").html(trial.answer);
        $("#det").html(trial.det);
        $("#item").html(trial.item);
        $("#question").html(trial.question[0] + trial.item + trial.question[1]);
        
        $("#unit1").html(trial.unit);
        $("#unit2").html(trial.unit);
        $("#dim").html(trial.dim);
        /*
        $("#gender1").html(gender);
        $("#gender2").html(gender);
        $("#name1").html(name);
        $("#name2").html(name);
        $("#pronoun1").html(pronoun1);
        $("#pronoun2").html(pronoun2);
        $("#pronoun3").html(pronoun3);
        //$("#des").html(res);
        $("#utterance").html(res);
        */
        var textbox;
      if (trial.dim==="tall") {
          textbox = '<input type="text" name="response1" /> ' + trial.unit[0] + ' and <input type="text" name="response2" /> ' + trial.unit[1];
      } else {
        textbox = '<input type="text" name="response" /> ' + trial.unit;
      }

        $("#textbox").html(textbox);
      
      
      numComplete++;
      
    }
  }
}

