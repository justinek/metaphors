var NUM_SLIDERS = 1;

function shuffle(o){ //v1.0
    for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
};

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
{"categoryID":1,"determiner":"an","animal":"ant","f1":"small","f2":"strong","f3":"busy", "f1_super": "smallest", "f2_super": "strongest", "f3_super": "busiest"},
{"categoryID":3,"determiner":"a","animal":"bear","f1":"scary","f2":"big","f3":"fierce", "f1_super": "scariest", "f2_super": "biggest", "f3_super": "fiercest"},
{"categoryID":4,"determiner":"a","animal":"bee","f1":"busy","f2":"small","f3":"angry", "f1_super": "busiest", "f2_super": "smallest", "f3_super": "angriest"},
{"categoryID":10,"determiner":"a","animal":"dolphin","f1":"smart","f2":"friendly","f3":"playful", "f1_super": "smartest", "f2_super": "friendliest", "f3_super": "most playful"},
{"categoryID":14,"determiner":"a","animal":"fox","f1":"sly","f2":"smart","f3":"pretty", "f1_super": "sliest", "f2_super": "smartest", "f3_super": "prettiest"},
{"categoryID":15,"determiner":"a","animal":"frog","f1":"slimy","f2":"noisy","f3":"jumpy", "f1_super": "slimiest", "f2_super": "noisiest", "f3_super": "jumpiest"},
{"categoryID":18,"determiner":"a","animal":"horse","f1":"fast","f2":"strong","f3":"beautiful", "f1_super": "fastest", "f2_super": "strongest", "f3_super": "most beautiful"},
{"categoryID":20,"determiner":"a","animal":"lion","f1":"scary","f2":"strong","f3":"ferocious", "f1_super": "scariest", "f2_super": "strongest", "f3_super": "most ferocious"},
{"categoryID":21,"determiner":"a","animal":"monkey","f1":"funny","f2":"smart","f3":"playful", "f1_super": "funniest", "f2_super": "smartest", "f3_super": "most playful"},
{"categoryID":22,"determiner":"an","animal":"owl","f1":"wise","f2":"quiet","f3":"nocturnal", "f1_super": "wisest", "f2_super": "most quiet", "f3_super": "most nocturnal"},
{"categoryID":23,"determiner":"an","animal":"ox","f1":"strong","f2":"big","f3":"slow", "f1_super": "strongest", "f2_super": "biggest", "f3_super": "slowest"},
{"categoryID":26,"determiner":"a","animal":"rabbit","f1":"fast","f2":"furry","f3":"cute", "f1_super": "fastest", "f2_super": "furriest", "f3_super": "cutest"},
{"categoryID":27,"determiner":"a","animal":"shark","f1":"scary","f2":"mean","f3":"dangerous", "f1_super": "scariest", "f2_super": "meanest", "f3_super": "most dangerous"},
{"categoryID":29,"determiner":"a","animal":"tiger","f1":"striped","f2":"fierce","f3":"scary", "f1_super": "most striped", "f2_super": "fiercest", "f3_super": "scariest"},
{"categoryID":30,"determiner":"a","animal":"whale","f1":"large","f2":"graceful","f3":"majestic", "f1_super": "largest", "f2_super": "most graceful", "f3_super": "most majestic"},
{"categoryID":32,"determiner":"a","animal":"zebra","f1":"striped","f2":"exotic","f3":"fast", "f1_super": "most striped", "f2_super": "most exotic", "f3_super": "fastest"},
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
var condition;
var featureNum;
var feature;
//var comparisonClass = ["none", "animals", "people", "different"].random();

showSlide("instructions");
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);


var experiment = {
  //compClass: comparisonClass,
	categoryIDs: new Array(numTrials),
  	orders: new Array(numTrials),
  	animals: new Array(numTrials),
    //names: new Array(numTrials),
    conditions: new Array(numTrials),
    featureNums: new Array(numTrials),
    features: new Array(numTrials),
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
      experiment.categoryIDs[currentTrialNum] = trial.categoryID;
      experiment.animals[currentTrialNum] = trial.animal;
      //experiment.names[currentTrialNum] = speaker;
      experiment.conditions[currentTrialNum] = conditionType;
      experiment.featureNums[currentTrialNum] = featureNum;
      experiment.features[currentTrialNum] = feature;
      

      experiment.ratings[currentTrialNum] = parseFloat(document.getElementById("hiddenSliderValue1").value);
    

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

      condition = random(0, 1);
      if (condition == 0) {
        conditionType = "animal";
        $("#animal").html(trial.animal);
        $("#determiner").html(trial.determiner);
      } else {
        conditionType = "person";
        $("#animal").html("person");
        $("#determiner").html("a");
      }

      featureNum = random(1, 3);
      if (featureNum == 1) {
        $("#feature").html(trial.f1);
        $("#low").html(trial.f1);
        $("#high").html(trial.f1_super);
        feature = trial.f1;
      } else if (featureNum == 2) {
        $("#feature").html(trial.f2);
        $("#low").html(trial.f2);
        $("#high").html(trial.f2_super);
        feature = trial.f2;
      } else {
        $("#feature").html(trial.f3);
        $("#low").html(trial.f3);
        $("#high").html(trial.f3_super);
        feature =trial.f3;
      }
      
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

