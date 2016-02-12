var NUM_SLIDERS = 2;

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
  for(var i=1; i<=NUM_SLIDERS; i++)
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
{"dimension": "height", "quality": "tall", "figurative": "He's a giraffe", "literal": "He's tall", "gender": "male"},
{"dimension": "sweetness", "quality": "sweet", "figurative": "She's a sugarcane", "literal": "She's sweet", "gender": "female"},
]

];

var discourseConditions = shuffle(["figurative", "literal"]);
var names_f = shuffle(["Amy", "Ann", "Cheryl", "Heather", "Rachel", "Nicole"]);
var names_m = shuffle(["Joseph", "Mark", "Matthew", "Paul", "Derek", "Jeffrey"]);
var names_all = shuffle(names_f.concat(names_m));

var debug = false;
if(debug) { allConditions = debugConditions; }


var numConditions = allConditions.length;
var chooseCondition = random(0, numConditions-1);
var shuffledTrials = shuffle(allConditions[chooseCondition]);
var numTrials = shuffledTrials.length;

var currentTrialNum = 0;
var trial;
var numComplete = 0;
var speaker;
var responseType;
var gender;
var discourseOrder;
var option1Type;
var option2Type;

showSlide("instructions");
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);


var experiment = {
  condition: chooseCondition + 1,
  
  option1: new Array(numTrials),
  option2: new Array(numTrials),
  option1Types: new Array(numTrials),
  option2Types: new Array(numTrials),  
  orders: new Array(numTrials),
  discourseOrders: new Array(numTrials),
  qualities: new Array(numTrials),
  
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
      //var price = 0;//parseFloat(document.price.score.value) + parseFloat(document.price.score1.value) / 100.00;
      
      var rating1 = parseFloat(document.getElementById("hiddenSliderValue1").value);
      var rating2 = parseFloat(document.getElementById("hiddenSliderValue2").value);
      //var prob10 = parseInt(document.getElementById("hiddenSliderValue10").value) / 40.00;
      
      
      
      experiment.option1[currentTrialNum] = rating1;
      experiment.option2[currentTrialNum] = rating2;
      experiment.option1Types[currentTrialNum] = option1Type;
      experiment.option2Types[currentTrialNum] = option2Type;

      experiment.discourseOrders[currentTrialNum] = discourseOrder;

      experiment.qualities[currentTrialNum] = trial.quality;
      
      experiment.orders[currentTrialNum] = numComplete;
      
          
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
      var pronoun1;
      var pronoun2;
      var A;
      var B;
      var optionA;
      var optionB;
      if (trial.gender=="male") {
        pronoun1="his";
        pronoun2="He";
        A = names_m.shift();
        B = names_f.shift();
        optionA = names_m.shift();
        optionB = names_m.shift();

      } else {
        pronoun1="her";
        pronoun2="She";
        A = names_f.shift();
        B = names_m.shift();
        optionA = names_f.shift();
        optionB = names_f.shift();
      }
      
      var description1;
      var description2;
      if (discourseConditions[numComplete] == "literal") {
        discourseOrder = "lit-lit";
        description1 = trial.literal;
        description2 = trial.literal + ", too";
        option1Type = "literal";
        option2Type = "literal";
      } else {
        if (random(0, 1) == 1) {
          discourseOrder = "lit-fig";
          description1 = trial.literal;
          description2 = trial.figurative;
          option1Type = "literal";
          option2Type = "figurative"
        } else {
          discourseOrder = "fig-lit";
          description1 = trial.figurative;
          description2 = trial.literal;
          option1Type = "figurative";
          option2Type = "literal";
        }
      }

      $('#slider1 .ui-slider-handle').hide();
      $('#slider2 .ui-slider-handle').hide();

    

        $("#pronoun1").html(pronoun1);
        $("#pronoun2").html(pronoun2);
        $("#a1").html(A);
        $("#a2").html(A);
        $("#a3").html(A);
        $("#a4").html(A);
        $("#b1").html(B);
        $("#b2").html(B);
        $("#b3").html(B);
        $("#b4").html(B);
        $("#b5").html(B);
        $("#optionA1").html(optionA);
        $("#optionA2").html(optionA);
        $("#optionA3").html(optionA);
        $("#optionB1").html(optionB);
        $("#optionB2").html(optionB);
        $("#optionB3").html(optionB);
        $("#quality1").html(trial.quality);
        $("#quality2").html(trial.quality);
        $("#quality3").html(trial.quality);
        $("#quality4").html(trial.quality);
        $("#quality5").html(trial.quality);
        $("#quality6").html(trial.quality);
        $("#quality7").html(trial.quality);

        $("#description1").html(description1);
        $("#description2").html(description2);

      
      numComplete++;
      
    }
  }
}

// scripts for sliders
$("#slider1").slider({
               animate: true,
               orientation: "horizontal",
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
               orientation: "horizontal",
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

