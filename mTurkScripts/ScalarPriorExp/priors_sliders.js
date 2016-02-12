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
  var sliderVar = "";
  for(var i=0; i<NUM_SLIDERS; i++)
  {
    sliderVar = "#slider" + i;
    $(sliderVar).slider("value", 20);
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
{"item": "giraffe", "dimension": "height", "det": "a", "question": "How likely do you think the giraffe is the following heights?", "unit": "feet", "bins": [0.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 15]},
{"item": "hamster", "dimension": "height", "det": "a",  "question": "How likely do you think the hamster is the following heights?", "unit": "feet", "bins": [0.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 15]},
{"item": "cheetah", "dimension": "speed", "det": "a", "question": "How likely do you think the cheetah can run at the following speeds?", "unit": "miles per hour", "bins": [1, 5, 10, 12, 14, 16, 18, 20, 60]},
{"item": "turtle", "dimension": "speed", "det": "a", "question": "How likely do you think the turtle can run at the following speeds?", "unit": "miles per hour", "bins": [1, 5, 10, 12, 14, 16, 18, 20, 60]},
{"item": "elephant", "dimension": "weight", "det": "an", "question": "How likely do you think the elephant weighs the following amounts?", "unit": "pounds", "bins": [10, 100, 120, 140, 160, 180, 200, 220, 10000]},
{"item": "bird", "dimension": "weight", "det": "a", "question": "How likely do you think the bird weighs the following amounts?", "unit": "pounds", "bins": [10, 100, 120, 140, 160, 180, 200, 220, 10000]},
{"item": "man", "dimension": "height", "det": "a", "question": "How likely do you think the man is the following heights?", "unit": "feet", "bins": [0.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 15]},
{"item": "man", "dimension": "speed", "det": "a", "question": "How likely do you think the man can run at the following speeds?", "unit": "miles per hour", "bins": [1, 5, 10, 12, 14, 16, 18, 20, 60]},
{"item": "man", "dimension": "weight", "det": "a", "question": "How likely do you think the man weighs the following amounts?", "unit": "pounds", "bins": [10, 100, 120, 140, 160, 180, 200, 220, 10000]},
{"item": "woman", "dimension": "height", "det": "a", "question": "How likely do you think the woman is the following heights?", "unit": "feet", "bins": [0.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 15]},
{"item": "woman", "dimension": "speed", "det": "a", "question": "How likely do you think the woman can run at the following speeds?", "unit": "miles per hour", "bins": [1, 5, 10, 12, 14, 16, 18, 20, 60]},
{"item": "woman", "dimension": "weight", "det": "a", "question": "How likely do you think the woman weighs the following amounts?", "unit": "pounds", "bins": [10, 100, 120, 140, 160, 180, 200, 220, 10000]},
]
];


var debug = false;
if(debug) { allConditions = debugConditions; }


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
	condition: chooseCondition + 1,
	
  priors0: new Array(numTrials),
  priors1: new Array(numTrials),
  priors2: new Array(numTrials),
  priors3: new Array(numTrials),
  priors4: new Array(numTrials),
  priors5: new Array(numTrials),
  priors6: new Array(numTrials),
  priors7: new Array(numTrials),
  priors8: new Array(numTrials),
  priors9: new Array(numTrials),
  //priors10: new Array(numTrials),
  
  bins0: new Array(numTrials),
  bins1: new Array(numTrials),
  bins2: new Array(numTrials),
  bins3: new Array(numTrials),
  bins4: new Array(numTrials),
  bins5: new Array(numTrials),
  bins6: new Array(numTrials),
  bins7: new Array(numTrials),
  bins8: new Array(numTrials),
  bins9: new Array(numTrials),
  
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
      //var price = 0;//parseFloat(document.price.score.value) + parseFloat(document.price.score1.value) / 100.00;
      
      var prob0 = parseFloat(document.getElementById("hiddenSliderValue0").value);
      var prob1 = parseFloat(document.getElementById("hiddenSliderValue1").value);
      var prob2 = parseFloat(document.getElementById("hiddenSliderValue2").value);
      var prob3 = parseFloat(document.getElementById("hiddenSliderValue3").value);
      var prob4 = parseFloat(document.getElementById("hiddenSliderValue4").value);
      var prob5 = parseFloat(document.getElementById("hiddenSliderValue5").value);
      var prob6 = parseFloat(document.getElementById("hiddenSliderValue6").value);
      var prob7 = parseFloat(document.getElementById("hiddenSliderValue7").value);
      var prob8 = parseFloat(document.getElementById("hiddenSliderValue8").value);
      var prob9 = parseFloat(document.getElementById("hiddenSliderValue9").value);
      //var prob10 = parseInt(document.getElementById("hiddenSliderValue10").value) / 40.00;
      
      
      
      experiment.priors0[currentTrialNum] = prob0;
      experiment.priors1[currentTrialNum] = prob1;
      experiment.priors2[currentTrialNum] = prob2;
      experiment.priors3[currentTrialNum] = prob3;
      experiment.priors4[currentTrialNum] = prob4;
      experiment.priors5[currentTrialNum] = prob5;
      experiment.priors6[currentTrialNum] = prob6;
      experiment.priors7[currentTrialNum] = prob7;
      experiment.priors8[currentTrialNum] = prob8;
      experiment.priors9[currentTrialNum] = prob9;
      experiment.bins0[currentTrialNum] = 0;
      experiment.bins1[currentTrialNum] = trial.bins[0];
      experiment.bins2[currentTrialNum] = trial.bins[1];
      experiment.bins3[currentTrialNum] = trial.bins[2];
      experiment.bins4[currentTrialNum] = trial.bins[3];
      experiment.bins5[currentTrialNum] = trial.bins[4];
      experiment.bins6[currentTrialNum] = trial.bins[5];
      experiment.bins7[currentTrialNum] = trial.bins[6];
      experiment.bins8[currentTrialNum] = trial.bins[7];
      experiment.bins9[currentTrialNum] = trial.bins[8];
      //experiment.priors10[currentTrialNum] = prob10;
      
      
      
      experiment.orders[currentTrialNum] = numComplete;
      
      experiment.items[currentTrialNum] = trial.item;

      experiment.dimensions[currentTrialNum] = trial.dimension;
      
        	
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

      showSlide("stage");
      $("#answer").html(trial.answer);
        $("#det").html(trial.det);
        $("#item").html(trial.item);
        $("#question").html(trial.question);
        $("#unit1").html(trial.unit);
        $("#unit2").html(trial.unit);
      

      
      $("#min0").html(trial.bins[0]);

      for (var i = 0; i <= 9; i++)
      {        
        var minIndex = i+1;
        
        $("#min" + minIndex).html(trial.bins[i]);
        $("#max" + i).html(trial.bins[i]);
        $('#slider' + i + ' .ui-slider-handle').hide();

      }

      $("#min9").html(trial.bins[8]);

      
      numComplete++;
      
    }
  }
}

// scripts for sliders
$("#slider0").slider({
               animate: true,
               orientation: "vertical",
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider0 .ui-slider-handle').show();
                   $("#slider0 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue0').attr('value', ui.value);
                   $("#slider0").css({"background":"#99D6EB"});
                   $("#slider0 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
$("#slider1").slider({
               animate: true,
               orientation: "vertical",
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
               orientation: "vertical",
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
               orientation: "vertical",
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
               orientation: "vertical",
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
$("#slider5").slider({
               animate: true,
               orientation: "vertical",
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider5 .ui-slider-handle').show();
                   $("#slider5 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue5').attr('value', ui.value);
                   $("#slider5").css({"background":"#99D6EB"});
                   $("#slider5 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
               
$("#slider6").slider({
               animate: true,
               orientation: "vertical",
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider6 .ui-slider-handle').show();
                   $("#slider6 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue6').attr('value', ui.value);
                   $("#slider6").css({"background":"#99D6EB"});
                   $("#slider6 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});

$("#slider7").slider({
               animate: true,
               orientation: "vertical",
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider7 .ui-slider-handle').show();
                   $("#slider7 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue7').attr('value', ui.value);
                   $("#slider7").css({"background":"#99D6EB"});
                   $("#slider7 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});

$("#slider8").slider({
               animate: true,
               orientation: "vertical",
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider8 .ui-slider-handle').show();
                   $("#slider8 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue8').attr('value', ui.value);
                   $("#slider8").css({"background":"#99D6EB"});
                   $("#slider8 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});

$("#slider9").slider({
               animate: true,
               orientation: "vertical",
               max: 1 , min: 0, step: 0.01, value: 0.5,
               slide: function( event, ui ) {
                $('#slider9 .ui-slider-handle').show();
                   $("#slider9 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue9').attr('value', ui.value);
                   $("#slider9").css({"background":"#99D6EB"});
                   $("#slider9 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
               


