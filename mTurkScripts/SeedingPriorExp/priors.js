function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function showSlide(id) {
  $(".slide").hide();
  $("#"+id).show();
}

function shuffle(array) {
  var currentIndex = array.length, temporaryValue, randomIndex ;

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

function random(a,b) {
  if (typeof b == "undefined") {
    a = a || 2;
    return Math.floor(Math.random()*a);
  } else {
    return Math.floor(Math.random()*(b-a+1)) + a;
  }
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


var allConditions = 
[
[
{"featureID": 1, "feature": "small", "animals": ["turtle","hippo","donkey","bee","jaguar","monkey","cow","dolphin","deer","dog","pig","hyena","ant","lion","cat","cheetah","beaver","mule","mouse","bird","man"], "numAnimals":21},
//{"featureID": 2, "feature": "industrious", "animals": ["jaguar","monkey","cat","ant","beaver","cheetah","bee","mouse","bird","man"], "numAnimals":10},
/*
{"featureID": 3, "feature": "big", "animals": ["turtle","sloth","donkey","eagle","deer","pig","lion","mouse","panda","horse","monkey","elephant","cheetah","bird","hippo","bear","mule","tiger","armadillo","kitten","whale","man","jaguar","cow","dog","cat","gorilla"], "numAnimals":27},
{"featureID": 4, "feature": "majestic", "animals": ["turtle","eagle","horse","monkey","cow","hippo","elephant","dog","bear","cat","gorilla","lion","armadillo","kitten","whale","panda","man"], "numAnimals":17},
{"featureID": 5, "feature": "fast", "animals": ["turtle","sloth","donkey","eagle","fish","dolphin","deer","pig","ant","lion","zebra","beaver","cat","mouse","horse","monkey","eel","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","giraffe","snake","rabbit","kitten","whale","man","jaguar","cow","dog","bee","hyena","gorilla"], "numAnimals":37},
{"featureID": 6, "feature": "hard", "animals": ["turtle","eagle","horse","jaguar","monkey","cow","sloth","kitten","dog","bear","cat","tiger","gorilla","lion","armadillo","hippo","elephant","cheetah","whale","panda","man"], "numAnimals":21},
{"featureID": 7, "feature": "cute", "animals": ["turtle","sloth","donkey","hippo","fish","dolphin","deer","pig","ant","lion","mouse","panda","horse","monkey","eel","cougar","elephant","cheetah","man","bird","eagle","bear","mule","snake","rabbit","kitten","whale","penguin","jaguar","cow","dog","cat","hyena","gorilla"], "numAnimals":34},
{"featureID": 8, "feature": "funny", "animals": ["beaver","ant","penguin","jaguar","monkey","dolphin","deer","dog","bear","bee","hyena","gorilla","lion","kitten","cheetah","whale","cat","mouse","bird","elephant","man"], "numAnimals":21},
{"featureID": 9, "feature": "smart", "animals": ["fish","dolphin","deer","ant","lion","beaver","bee","mouse","horse","monkey","eel","cougar","elephant","cheetah","man","bird","bear","snake","kitten","whale","penguin","jaguar","dog","cat","hyena","gorilla"], "numAnimals":26},
{"featureID": 10, "feature": "tall", "animals": ["sloth","horse","giraffe","snake","man"], "numAnimals":5},
{"featureID": 11, "feature": "long", "animals": ["sloth","horse","jaguar","eel","fish","dolphin","cat","cougar","giraffe","snake","cheetah","man"], "numAnimals":12},
{"featureID": 12, "feature": "agile", "animals": ["turtle","donkey","fish","dolphin","deer","pig","ant","zebra","beaver","bee","mouse","horse","monkey","gorilla","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","snake","rabbit","kitten","man","jaguar","cow","dog","cat","eel"], "numAnimals":31},
{"featureID": 13, "feature": "slow", "animals": ["turtle","sloth","donkey","deer","pig","mouse","horse","elephant","cheetah","bird","hippo","bear","mule","giraffe","armadillo","snake","kitten","whale","man","jaguar","cow","dog","cat","gorilla"], "numAnimals":24},
{"featureID": 14, "feature": "strong", "animals": ["turtle","sloth","donkey","eagle","fish","dolphin","deer","pig","lion","zebra","mouse","horse","monkey","eel","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","giraffe","armadillo","snake","whale","man","jaguar","cow","dog","cat","hyena","gorilla"], "numAnimals":33},
{"featureID": 15, "feature": "fierce", "animals": ["eagle","horse","jaguar","monkey","dog","bear","cat","tiger","gorilla","lion","zebra","hyena","elephant","cheetah","whale","bird","man"], "numAnimals":17},
{"featureID": 16, "feature": "quiet", "animals": ["turtle","hippo","donkey","jaguar","monkey","cow","deer","dog","mule","cat","ant","cheetah","beaver","pig","mouse","bird","man"], "numAnimals":17},
{"featureID": 17, "feature": "busy", "animals": ["jaguar","monkey","bee","ant","cheetah","beaver","mouse","man"], "numAnimals":8},
{"featureID": 18, "feature": "proud", "animals": ["eagle","horse","cat","lion","elephant","whale","man"], "numAnimals":7},
{"featureID": 19, "feature": "sleek", "animals": ["turtle","donkey","fish","dolphin","deer","pig","ant","zebra","beaver","bee","mouse","horse","monkey","gorilla","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","snake","rabbit","kitten","man","jaguar","cow","dog","cat","eel"], "numAnimals":31},
{"featureID": 20, "feature": "lazy", "animals": ["turtle","sloth","donkey","hippo","fish","dolphin","deer","pig","ant","lion","mouse","panda","horse","monkey","eel","cougar","elephant","cheetah","man","bird","eagle","bear","mule","giraffe","armadillo","snake","rabbit","kitten","whale","penguin","jaguar","cow","dog","cat","hyena","gorilla"], "numAnimals":36},
{"featureID": 21, "feature": "loyal", "animals": ["turtle","sloth","donkey","dolphin","deer","pig","lion","mouse","panda","monkey","elephant","cheetah","penguin","bird","hippo","mule","rabbit","kitten","whale","man","jaguar","cow","dog","cat","hyena"], "numAnimals":25},
{"featureID": 22, "feature": "friendly", "animals": ["turtle","sloth","donkey","dolphin","deer","pig","lion","mouse","panda","monkey","elephant","cheetah","penguin","bird","hippo","mule","rabbit","kitten","whale","man","jaguar","cow","dog","cat","hyena"], "numAnimals":25},
{"featureID": 23, "feature": "playful", "animals": ["sloth","jaguar","monkey","elephant","dog","cat","hyena","rabbit","kitten","cheetah","whale","man","panda","penguin"], "numAnimals":14},
{"featureID": 24, "feature": "loud", "animals": ["monkey","dolphin","dog","cat","hyena","lion","kitten","man","bird","penguin"], "numAnimals":10},
{"featureID": 25, "feature": "happy", "animals": ["horse","jaguar","monkey","eel","fish","dolphin","dog","cat","hyena","cougar","snake","cheetah","bird","man"], "numAnimals":14},
{"featureID": 26, "feature": "slithery", "animals": ["sloth","horse","jaguar","eel","fish","dolphin","cat","cougar","giraffe","snake","cheetah","man"], "numAnimals":12},
{"featureID": 27, "feature": "dumb", "animals": ["turtle","hippo","donkey","jaguar","monkey","cow","deer","dog","mule","cat","cheetah","pig","mouse","bird","man"], "numAnimals":15},
{"featureID": 28, "feature": "hairy", "animals": ["turtle","sloth","horse","jaguar","monkey","bear","cat","tiger","gorilla","lion","elephant","cheetah","whale","man"], "numAnimals":14},
{"featureID": 29, "feature": "striped", "animals": ["horse","jaguar","bear","tiger","gorilla","lion","zebra","elephant","cheetah","man"], "numAnimals":10},
{"featureID": 30, "feature": "slippery", "animals": ["horse","jaguar","cougar","fish","dolphin","cat","eel","snake","cheetah","man"], "numAnimals":10},
{"featureID": 31, "feature": "slimy", "animals": ["horse","jaguar","eel","fish","dolphin","cat","cougar","snake","cheetah","man"], "numAnimals":10},
{"featureID": 32, "feature": "scaly", "animals": ["horse","jaguar","cougar","fish","dolphin","cat","eel","snake","cheetah","man"], "numAnimals":10},
{"featureID": 33, "feature": "stubborn", "animals": ["turtle","hippo","donkey","jaguar","cow","sloth","deer","dog","mule","cat","cheetah","pig","mouse","bird","man"], "numAnimals":15},
{"featureID": 34, "feature": "fat", "animals": ["turtle","hippo","donkey","jaguar","cow","pig","deer","dog","mule","elephant","cheetah","whale","cat","mouse","bird","man"], "numAnimals":16},
{"featureID": 35, "feature": "dirty", "animals": ["turtle","hippo","donkey","jaguar","cow","deer","dog","mule","pig","cheetah","cat","mouse","bird","man"], "numAnimals":14},
*/
]
];

var NUM_SLIDERS;

var numConditions = allConditions.length;
var chooseCondition = random(0, numConditions-1);
var allTrialOrders = allConditions[chooseCondition];
var numTrials = allTrialOrders.length;
var shuffledOrder = shuffledSampleArray(allTrialOrders.length, numTrials);
var currentTrialNum = 0;
var trial;
var numComplete = 0;
var ratingArray;
var numRatings;
var animalArray;
//var comparisonClass = ["none", "animals", "people", "different"].random();

showSlide("instructions");
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);


var experiment = {
  //compClass: comparisonClass,
	  featureIDs: new Array(numTrials),
    features: new Array(numTrials),
  	orders: new Array(numTrials),
  	animals: new Array(numTrials),
    numAnimals: new Array(numTrials),
    //names: new Array(numTrials),
    ratings: new Array(numTrials),

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
      //experiment.adjectives[currentTrialNum] = document.adjective.adj.value;    
      experiment.orders[currentTrialNum] = numComplete;
      experiment.featureIDs[currentTrialNum] = trial.featureID;
      experiment.features[currentTrialNum] = trial.feature;
        
      //experiment.names[currentTrialNum] = speaker;
      
      //animalArray = animalArray.random();

      experiment.animals[currentTrialNum] = animalArray;

      numRatings = trial.numAnimals;
      NUM_SLIDERS = numRatings;

      experiment.numAnimals[currentTrialNum] = numRatings;
      //names: new Array(numTrials),
      ratingArray = new Array(numRatings);

      for(var i=0; i<numRatings; i++) {
        ratingArray[i] = parseFloat(document.getElementById("hiddenSliderValue" + i).value);
      }
      

      experiment.ratings[currentTrialNum] = ratingArray;
    

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
    	trial = allTrialOrders[shuffledOrder[numComplete]];
      animalArray = trial.animals.slice(0);
      shuffle(animalArray);
      showSlide("stage");

      $("#animal0").html(animalArray[0]);

      for (var i = 0; i < numRatings; i++) {
        $("#animal" + i).html(trial.animals[i]);
      }


      for (var i = 1; i <= NUM_SLIDERS; i++) {        
          $('#slider' + i + ' .ui-slider-handle').hide();

        }

      

      $("#feature").html(trial.feature);

      //$("#name").html(speaker);
      
      numComplete++;
    }
  }
}

// scripts for sliders
               

$("#slider1").slider({
               animate: true,
               
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider1 .ui-slider-handle').show();
                   $("#slider1 .ui-slider-handle").css({

                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue1').attr('value', ui.value);
                   $("#slider1").css({"background":"#99D6EB"});
                   $("#slider1 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
               
$("#slider2").slider({
               animate: true,
               
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider2 .ui-slider-handle').show();
                   $("#slider2 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue2').attr('value', ui.value);
                   $("#slider2").css({"background":"#99D6EB"});
                   $("#slider2 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
               
$("#slider3").slider({
               animate: true,
               
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider3 .ui-slider-handle').show();
                   $("#slider3 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue3').attr('value', ui.value);
                   $("#slider3").css({"background":"#99D6EB"});
                   $("#slider3 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
$("#slider4").slider({
               animate: true,
               
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider4 .ui-slider-handle').show();
                   $("#slider4 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue4').attr('value', ui.value);
                   $("#slider4").css({"background":"#99D6EB"});
                   $("#slider4 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});

