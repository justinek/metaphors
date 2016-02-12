var NUM_SLIDERS = 1;

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

function determiner(word) {
  var vowels = ['a', 'e', 'i', 'o', 'u'];
  for (var i=0; i < vowels.length; i++) {
    var vowel = vowels[i];
    if (word[0] === vowel) {
      return "an";
    }
  }
  return "a";
}

function clearForm(oForm) {
  var sliderVar = "";
  for(var i=1; i<= NUM_SLIDERS; i++)
  {
    sliderVar = "#slider" + i;
    $(sliderVar).slider("value", 0.5);
    $(sliderVar).css({"background":"#FFFFFF"});
    $(sliderVar + " .ui-slider-handle").css({
        "background":"#FAFAFA",
        "border-color": "#CCCCCC" });
    sliderVar = "slider" + i;
    document.getElementById(sliderVar).style.background = "";
  }
  
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

// directly returns a shuffled array
function shuffle(o){ //v1.0
    for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}

function repeat(element, numTimes) {
  var array = new Array(numTimes)
  for (var i=0; i < numTimes; i++) {
    array[i] = element;
  }
  return array;
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

function getRandomInt (min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

var allSpeakers = ["Alex", "Bob", "Calvin", "David", "Eric", "Frank", "George", 
"Harry", "Ivan", "Jake", "Kenneth", "Luke", "Matt", "Nathan", "Owen",
"Patrick", "Quinn", "Robert", "Steve", "Tom", "Victor", 
"Winston", "Zach", "Albert", "Barry", "Charles", "Daniel", "Ethan", "Fred", "Gary", "Henry",
"Jeff"];


var allConditions = 
[
[
{"animalID": 1, "animal": "ant", "features": ["small","industrious"]},
{"animalID": 2, "animal": "whale", "features": ["big","majestic"]},

{"animalID": 3, "animal": "bird", "features": ["fast","small"]},
{"animalID": 4, "animal": "elephant", "features": ["big","hard"]},
{"animalID": 5, "animal": "panda", "features": ["cute","big"]},
{"animalID": 6, "animal": "monkey", "features": ["funny","smart"]},
{"animalID": 7, "animal": "penguin", "features": ["funny","cute"]},
{"animalID": 8, "animal": "giraffe", "features": ["tall","long"]},
{"animalID": 9, "animal": "cheetah", "features": ["fast","agile"]},
{"animalID": 10, "animal": "turtle", "features": ["slow","strong"]},
{"animalID": 11, "animal": "lion", "features": ["fierce","strong"]},
{"animalID": 12, "animal": "rabbit", "features": ["fast","cute"]},

]
];


var numConditions = allConditions.length;
var chooseCondition = random(0, numConditions-1);
var allTrialOrders = allConditions[chooseCondition];
var numTrials = allTrialOrders.length;
//var shuffledOrder = shuffledSampleArray(allTrialOrders.length, numTrials);
var shuffledTrials = shuffle(allTrialOrders);
var answerTypes = shuffle(repeat("literal", numTrials / 4).concat(repeat("figurative", (numTrials / 4) * 3)));
// randomize order of trials to split into conditions
//var shuffledConditions = shuffledSampleArray(allTrialOrders.length, numTrials);

var currentTrialNum = 0;
var trial;
var numComplete = 0;
var shuffledSpeakerOrder = shuffledSampleArray(allTrialOrders.length, numTrials);
var speaker;
var trialIndex;
var qud;
var question;
var answer;
var trialCondition;

showSlide("instructions");
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);


var experiment = {
	  animalIDs: new Array(numTrials),
  	orders: new Array(numTrials),
  	animals: new Array(numTrials),
  	conditions: new Array(numTrials),
    QUDs: new Array(numTrials),
  	isMetaphors: new Array(numTrials),
    ratings: new Array(numTrials),
  	speakers: new Array(numTrials),
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
    var gen = getRadioCheckedValue(2, "genderButton");
    var ag = document.age.ageRange.value;
    var lan = document.language.nativeLanguage.value;
    var comm = document.comments.input.value;
    var incomeVal = document.income.incomeRange.value;
    experiment.gender = gen;
    experiment.age = ag;
    experiment.nativeLanguage = lan;
    experiment.comments = comm;
    experiment.income = incomeVal;
    clearForm(document.forms[2]);
    clearForm(document.forms[3]);
    clearForm(document.forms[4]);
    clearForm(document.forms[5]);
    clearForm(document.forms[6]);    
    showSlide("finished");
    setTimeout(function() {turk.submit(experiment) }, 1500);
  },
  next: function() {
    if (numComplete > 0) {
      //experiment.adjectives[currentTrialNum] = document.adjective.adj.value;    
	    experiment.speakers[currentTrialNum] = speaker;
      experiment.orders[currentTrialNum] = numComplete;
      experiment.animalIDs[currentTrialNum] = trial.animalID;
      experiment.animals[currentTrialNum] = trial.animal;
      experiment.conditions[currentTrialNum] = answerTypes[currentTrialNum];
      experiment.QUDs[currentTrialNum] = qud;
      experiment.isMetaphors[currentTrialNum] = getRadioCheckedValue(0, 'isMetaphor');
      experiment.ratings[currentTrialNum] = parseFloat(document.getElementById("hiddenSliderValue1").value);
      
      clearForm(document.forms[0]);
      clearForm(document.forms[1]);
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
    	speaker = allSpeakers[shuffledSpeakerOrder[numComplete]];
      showSlide("stage");
      $("#speaker1").html(speaker);
      $("#speaker2").html(speaker);
      $("#speaker3").html(speaker);
      var qudCondition = random(0, 2);
      var answerCondition = answerTypes[currentTrialNum];
      if (qudCondition == 0) {
        question = "What is he like?";
        qud = "null";
        if (answerCondition === "literal") {
          answer = "He is " + trial.features[1] + ".";
        } else {
          answer = "He is " + determiner(trial.animal) + " " + trial.animal + ".";
        }
      } else if (qudCondition == 1) {
        question = "Is he " + trial.features[0] + "?";
        qud = trial.features[0];
        if (answerCondition === "literal") {
          answer = "Yes.";
        } else {
          answer = "He is " + determiner(trial.animal) + " " + trial.animal + ".";
        }
      } else {
        question = "Is he " + trial.features[1] + "?";
        qud = trial.features[1];
        if (answerCondition === "literal") {
          answer = "Yes.";
        } else {
          answer = "He is " + determiner(trial.animal) + " " + trial.animal + ".";
        }
      }
      
      
      $("#question").html(question);
      $("#answer").html(answer);
      $("#answer2").html(answer);
      $('#slider1 .ui-slider-handle').hide();

      numComplete++;
    }
  }
}

// scripts for sliders
               

$("#slider1").slider({
               animate: true,
               
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                   $("#slider1 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue1').attr('value', ui.value);
                   $('#slider1 .ui-slider-handle').show();
                   $("#slider1").css({"background":"#99D6EB"});
                   $("#slider1 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});

