var NUM_SLIDERS = 4;

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

var allSpeakers = ["Alex", "Bob", "Calvin", "David", "Eric", "Frank", "George", 
"Harry", "Ivan", "Jake", "Kenneth", "Luke", "Matt", "Nathan", "Owen",
"Patrick", "Quinn", "Robert", "Steve", "Tom", "Victor", 
"Winston", "Zach", "Albert", "Barry", "Charles", "Daniel", "Ethan", "Fred", "Gary", "Henry",
"Jeff"];


var allConditions = 
[
[
{"categoryID":1,"determiner":"an","animal":"ant", "set1":"small; strong", "set2":"small; not strong", "set3":"not small; strong", "set4":"not small; not strong", },
{"categoryID":2,"determiner":"a","animal":"bat", "set1":"scary; blind", "set2":"scary; not blind", "set3":"not scary; blind", "set4":"not scary; not blind", },
{"categoryID":3,"determiner":"a","animal":"bear", "set1":"scary; big", "set2":"scary; not big", "set3":"not scary; big", "set4":"not scary; not big", },
{"categoryID":4,"determiner":"a","animal":"bee", "set1":"busy; small", "set2":"busy; not small", "set3":"not busy; small", "set4":"not busy; not small", },
{"categoryID":5,"determiner":"a","animal":"bird", "set1":"free; graceful", "set2":"free; not graceful", "set3":"not free; graceful", "set4":"not free; not graceful", },
{"categoryID":6,"determiner":"a","animal":"buffalo", "set1":"big; strong", "set2":"big; not strong", "set3":"not big; strong", "set4":"not big; not strong", },
{"categoryID":7,"determiner":"a","animal":"cat", "set1":"independent; lazy", "set2":"independent; not lazy", "set3":"not independent; lazy", "set4":"not independent; not lazy", },
{"categoryID":8,"determiner":"a","animal":"cow", "set1":"fat; dumb", "set2":"fat; not dumb", "set3":"not fat; dumb", "set4":"not fat; not dumb", },
{"categoryID":9,"determiner":"a","animal":"dog", "set1":"loyal; friendly", "set2":"loyal; not friendly", "set3":"not loyal; friendly", "set4":"not loyal; not friendly", },
{"categoryID":10,"determiner":"a","animal":"dolphin", "set1":"smart; friendly", "set2":"smart; not friendly", "set3":"not smart; friendly", "set4":"not smart; not friendly", },
{"categoryID":11,"determiner":"a","animal":"duck", "set1":"loud; cute", "set2":"loud; not cute", "set3":"not loud; cute", "set4":"not loud; not cute", },
{"categoryID":12,"determiner":"an","animal":"elephant", "set1":"huge; smart", "set2":"huge; not smart", "set3":"not huge; smart", "set4":"not huge; not smart", },
{"categoryID":13,"determiner":"a","animal":"fish", "set1":"scaly; wet", "set2":"scaly; not wet", "set3":"not scaly; wet", "set4":"not scaly; not wet", },
{"categoryID":14,"determiner":"a","animal":"fox", "set1":"sly; smart", "set2":"sly; not smart", "set3":"not sly; smart", "set4":"not sly; not smart", },
{"categoryID":15,"determiner":"a","animal":"frog", "set1":"slimy; noisy", "set2":"slimy; not noisy", "set3":"not slimy; noisy", "set4":"not slimy; not noisy", },
{"categoryID":16,"determiner":"a","animal":"goat", "set1":"funny; hungry", "set2":"funny; not hungry", "set3":"not funny; hungry", "set4":"not funny; not hungry", },
{"categoryID":17,"determiner":"a","animal":"goose", "set1":"loud; mean", "set2":"loud; not mean", "set3":"not loud; mean", "set4":"not loud; not mean", },
{"categoryID":18,"determiner":"a","animal":"horse", "set1":"fast; strong", "set2":"fast; not strong", "set3":"not fast; strong", "set4":"not fast; not strong", },
{"categoryID":19,"determiner":"a","animal":"kangaroo", "set1":"jumpy; bouncy", "set2":"jumpy; not bouncy", "set3":"not jumpy; bouncy", "set4":"not jumpy; not bouncy", },
{"categoryID":20,"determiner":"a","animal":"lion", "set1":"ferocious; scary", "set2":"ferocious; not scary", "set3":"not ferocious; scary", "set4":"not ferocious; not scary", },
{"categoryID":21,"determiner":"a","animal":"monkey", "set1":"funny; smart", "set2":"funny; not smart", "set3":"not funny; smart", "set4":"not funny; not smart", },
{"categoryID":22,"determiner":"an","animal":"owl", "set1":"wise; quiet", "set2":"wise; not quiet", "set3":"not wise; quiet", "set4":"not wise; not quiet", },
{"categoryID":23,"determiner":"an","animal":"ox", "set1":"strong; big", "set2":"strong; not big", "set3":"not strong; big", "set4":"not strong; not big", },
{"categoryID":24,"determiner":"a","animal":"penguin", "set1":"cold; cute", "set2":"cold; not cute", "set3":"not cold; cute", "set4":"not cold; not cute", },
{"categoryID":25,"determiner":"a","animal":"pig", "set1":"dirty; fat", "set2":"dirty; not fat", "set3":"not dirty; fat", "set4":"not dirty; not fat", },
{"categoryID":26,"determiner":"a","animal":"rabbit", "set1":"fast; furry", "set2":"fast; not furry", "set3":"not fast; furry", "set4":"not fast; not furry", },
{"categoryID":27,"determiner":"a","animal":"shark", "set1":"scary; dangerous", "set2":"scary; not dangerous", "set3":"not scary; dangerous", "set4":"not scary; not dangerous", },
{"categoryID":28,"determiner":"a","animal":"sheep", "set1":"wooly; fluffy", "set2":"wooly; not fluffy", "set3":"not wooly; fluffy", "set4":"not wooly; not fluffy", },
{"categoryID":29,"determiner":"a","animal":"tiger", "set1":"striped; fierce", "set2":"striped; not fierce", "set3":"not striped; fierce", "set4":"not striped; not fierce", },
{"categoryID":30,"determiner":"a","animal":"whale", "set1":"large; graceful", "set2":"large; not graceful", "set3":"not large; graceful", "set4":"not large; not graceful", },
{"categoryID":31,"determiner":"a","animal":"wolf", "set1":"scary; mean", "set2":"scary; not mean", "set3":"not scary; mean", "set4":"not scary; not mean", },
{"categoryID":32,"determiner":"a","animal":"zebra", "set1":"striped; exotic", "set2":"striped; not exotic", "set3":"not striped; exotic", "set4":"not striped; not exotic", },
]
];


var numConditions = allConditions.length;
var chooseCondition = random(0, numConditions-1);
var allTrialOrders = allConditions[chooseCondition];
var numTrials = allTrialOrders.length;
var shuffledOrder = shuffledSampleArray(allTrialOrders.length, numTrials);
var currentTrialNum = 0;
var trial;
var numComplete = 0;
var shuffledSpeakerOrder = shuffledSampleArray(allTrialOrders.length, numTrials);
var speaker;
var comparisonClass = ["none", "animals", "people", "different"].random();

showSlide("instructions");
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);


var experiment = {
  compClass: comparisonClass,
	condition:chooseCondition + 1,
	categoryIDs: new Array(numTrials),
  	orders: new Array(numTrials),
  	animals: new Array(numTrials),
    //names: new Array(numTrials),
    conditions: new Array(numTrials),
  	set1s: new Array(numTrials),
  	set2s: new Array(numTrials),
  	set3s: new Array(numTrials),
    set4s: new Array(numTrials),

  	set1probs: new Array(numTrials),
  	set2probs: new Array(numTrials),
  	set3probs: new Array(numTrials),
    set4probs: new Array(numTrials),

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
      experiment.categoryIDs[currentTrialNum] = trial.categoryID;
      experiment.animals[currentTrialNum] = trial.animal;
      //experiment.names[currentTrialNum] = speaker;
      experiment.conditions[currentTrialNum] = conditionType;
      experiment.set1s[currentTrialNum] = trial.set1;
      experiment.set2s[currentTrialNum] = trial.set2;
      experiment.set3s[currentTrialNum] = trial.set3;
      experiment.set4s[currentTrialNum] = trial.set4;
      

      experiment.set1probs[currentTrialNum] = parseFloat(document.getElementById("hiddenSliderValue".concat(shuffledSetOrder[0] + 1)).value);
      experiment.set2probs[currentTrialNum] = parseFloat(document.getElementById("hiddenSliderValue".concat(shuffledSetOrder[1] + 1)).value);
      experiment.set3probs[currentTrialNum] = parseFloat(document.getElementById("hiddenSliderValue".concat(shuffledSetOrder[2] + 1)).value);
      experiment.set4probs[currentTrialNum] = parseFloat(document.getElementById("hiddenSliderValue".concat(shuffledSetOrder[3] + 1)).value);
      

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
    	speaker = allSpeakers[shuffledSpeakerOrder[numComplete]];
      showSlide("stage");

      shuffledSetOrder = shuffledArray(4);
      $("#set".concat(shuffledSetOrder[0] + 1)).html(trial.set1);
      $("#set".concat(shuffledSetOrder[1] + 1)).html(trial.set2);
      $("#set".concat(shuffledSetOrder[2] + 1)).html(trial.set3);
      $("#set".concat(shuffledSetOrder[3] + 1)).html(trial.set4);


      for (var i = 1; i <= 4; i++) {        
          $('#slider' + i + ' .ui-slider-handle').hide();

        }

      // Prompt type
      var prompt = "";
      if (comparisonClass == "none") {
        condition = random(0, 1);
        if (condition == 0) {
          conditionType = "animal";
          prompt = "How likely is it that " + trial.determiner + " " + trial.animal + " has the following attributes?"
        } else {
          conditionType = "person";
          prompt = "How likely is it that a person has the following attributes?"
        }
      } else if (comparisonClass == "animals") {
        condition = random(0, 1);
        if (condition == 0) {
          conditionType = "animal";
          prompt = "How likely is it that " + trial.determiner + " " + trial.animal + " has the following attributes, compared to other kinds of animals?"
        } else {
          conditionType = "person";
          prompt = "How likely is it that a person has the following attributes, compared to other kinds of animals?"
        }

      }  else if (comparisonClass == "people") {
        condition = random(0, 1);
        if (condition == 0) {
          conditionType = "animal";
          prompt = "How likely is it that " + trial.determiner + " " + trial.animal + " has the following attributes, compared to people?"
        } else {
          conditionType = "person";
          prompt = "How likely is it that a person has the following attributes, compared to other people?"
        }
      } else {
        condition = random(0, 1);
        if (condition == 0) {
          conditionType = "animal";
          prompt = "How likely is it that " + trial.determiner + " " + trial.animal + " has the following attributes, compared to other kinds of animals?"
        } else {
          conditionType = "person";
          prompt = "How likely is it that a person has the following attributes, compared to other people?"
        }
      }

      $("#prompt").html(prompt);

      
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

