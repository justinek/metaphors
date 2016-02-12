/*
var names = _.shuffle(["Amy", "Becky", "Caitlin", "Diana", "Erica", "Fiona", "Gina", 
  "Hannah", "Iris", "Jessica", "Karen", "Laura", "Melissa", "Nancy", "Olga",
  "Patty", "Queenie", "Rosa", "Stacey", "Tania", "Vicky", 
  "Wendy", "Zara", "Alison", "Bria", "Cheryl", "Dora", "Emily", "Fawn", "Gloria", "Helen",
  "Jeanette"]);
*/

var names = _.shuffle(["Alex", "Bob", "Calvin", "David", "Eric", "Frank", "George", 
  "Harry", "Ivan", "Jake", "Kenneth", "Luke", "Matt", "Nathan", "Owen",
  "Patrick", "Quinn", "Robert", "Steve", "Tom", "Victor", 
  "Winston", "Zach", "Albert", "Barry", "Charles", "Daniel", "Ethan", "Fred", "Gary", "Henry",
  "Jeff"]);

var QUDs = _.shuffle(fillArray("f1", 8).concat(fillArray("f2", 8)).concat(fillArray("gen", 8)));
var utteranceTypes = _.shuffle(fillArray("fig", 12).concat(fillArray("lit", 12)));

function properArray(array) {
  for (var i=0; i < array.length; i++) {
    if (typeof array[i] == "undefined") {
      return false;
    }
    return true;
  }
}
function fillArray(value, len) {
  var arr = [];
  for (var i = 0; i < len; i++) {
    arr.push(value);
  }
  return arr;
}

function make_slides(f) {
  var   slides = {};

  slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });

  slides.instructions = slide({
    name : "instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.single_trial = slide({
    name: "single_trial",
    start: function() {
      $(".err").hide();
      $(".display_condition").html("You are in " + exp.condition + ".");
    },
    button : function() {
      response = $("#text_response").val();
      if (response.length == 0) {
        $(".err").show();
      } else {
        exp.data_trials.push({
          "trial_type" : "single_trial",
          "response" : response
        });
        exp.go(); //make sure this is at the *end*, after you log your data
      }
    },
  });

  slides.one_slider = slide({
    name : "one_slider",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */
    present : [
      {subject: "dog", object: "ball"},
      {subject: "cat", object: "windowsill"},
      {subject: "bird", object: "shiny object"},
    ],

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
      $(".err").hide();

      this.stim = stim; //I like to store this information in the slide so I can record it later.


      $(".prompt").html(stim.subject + "s like " + stim.object + "s.");
      this.init_sliders();
      exp.sliderPost = null; //erase current slider value
    },

    button : function() {
      if (exp.sliderPost == null) {
        $(".err").show();
      } else {
        this.log_responses();

        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
        _stream.apply(this);
      }
    },

    init_sliders : function() {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
      });
    },

    log_responses : function() {
      exp.data_trials.push({
        "trial_type" : "one_slider",
        "response" : exp.sliderPost
      });
    }
  });

  slides.multi_slider = slide({
    name : "multi_slider",
    present : _.shuffle([
{"categoryID":1,"animal":"ant", "alternative":"ant", "animalType":"orig", "f1":"small", "f2":"industrious","determiner":"an", "set1":"small; industrious", "set2":"small; lazy", "set3":"big; industrious", "set4":"big; lazy"},
{"categoryID":1,"animal":"ant", "alternative":"monkey", "animalType":"alt", "f1":"small", "f2":"industrious","determiner":"a", "set1":"small; industrious", "set2":"small; lazy", "set3":"big; industrious", "set4":"big; lazy"},
{"categoryID":2,"animal":"whale", "alternative":"whale", "animalType":"orig", "f1":"big", "f2":"majestic","determiner":"a", "set1":"big; majestic", "set2":"big; shabby", "set3":"small; majestic", "set4":"small; shabby"},
{"categoryID":2,"animal":"whale", "alternative":"hippo", "animalType":"alt", "f1":"big", "f2":"majestic","determiner":"a", "set1":"big; majestic", "set2":"big; shabby", "set3":"small; majestic", "set4":"small; shabby"},
{"categoryID":3,"animal":"bird", "alternative":"bird", "animalType":"orig", "f1":"fast", "f2":"small","determiner":"a", "set1":"fast; small", "set2":"fast; big", "set3":"slow; small", "set4":"slow; big"},
{"categoryID":3,"animal":"bird", "alternative":"jaguar", "animalType":"alt", "f1":"fast", "f2":"small","determiner":"a", "set1":"fast; small", "set2":"fast; big", "set3":"slow; small", "set4":"slow; big"},
{"categoryID":4,"animal":"elephant", "alternative":"elephant", "animalType":"orig", "f1":"big", "f2":"hard","determiner":"an", "set1":"big; hard", "set2":"big; soft", "set3":"small; hard", "set4":"small; soft"},
{"categoryID":4,"animal":"elephant", "alternative":"turtle", "animalType":"alt", "f1":"big", "f2":"hard","determiner":"a", "set1":"big; hard", "set2":"big; soft", "set3":"small; hard", "set4":"small; soft"},
{"categoryID":5,"animal":"panda", "alternative":"panda", "animalType":"orig", "f1":"cute", "f2":"big","determiner":"a", "set1":"cute; big", "set2":"cute; small", "set3":"ugly; big", "set4":"ugly; small"},
{"categoryID":5,"animal":"panda", "alternative":"dog", "animalType":"alt", "f1":"cute", "f2":"big","determiner":"a", "set1":"cute; big", "set2":"cute; small", "set3":"ugly; big", "set4":"ugly; small"},
{"categoryID":6,"animal":"monkey", "alternative":"monkey", "animalType":"orig", "f1":"funny", "f2":"smart","determiner":"a", "set1":"funny; smart", "set2":"funny; stupid", "set3":"serious; smart", "set4":"serious; stupid"},
{"categoryID":6,"animal":"monkey", "alternative":"monkey", "animalType":"alt", "f1":"funny", "f2":"smart","determiner":"a", "set1":"funny; smart", "set2":"funny; stupid", "set3":"serious; smart", "set4":"serious; stupid"},
{"categoryID":7,"animal":"penguin", "alternative":"penguin", "animalType":"orig", "f1":"funny", "f2":"cute","determiner":"a", "set1":"funny; cute", "set2":"funny; ugly", "set3":"serious; cute", "set4":"serious; ugly"},
{"categoryID":7,"animal":"penguin", "alternative":"monkey", "animalType":"alt", "f1":"funny", "f2":"cute","determiner":"a", "set1":"funny; cute", "set2":"funny; ugly", "set3":"serious; cute", "set4":"serious; ugly"},
{"categoryID":8,"animal":"giraffe", "alternative":"giraffe", "animalType":"orig", "f1":"tall", "f2":"long","determiner":"a", "set1":"tall; long", "set2":"tall; short", "set3":"petite; long", "set4":"petite; short"},
{"categoryID":8,"animal":"giraffe", "alternative":"horse", "animalType":"alt", "f1":"tall", "f2":"long","determiner":"a", "set1":"tall; long", "set2":"tall; short", "set3":"petite; long", "set4":"petite; short"},
{"categoryID":9,"animal":"cheetah", "alternative":"cheetah", "animalType":"orig", "f1":"fast", "f2":"agile","determiner":"a", "set1":"fast; agile", "set2":"fast; clumsy", "set3":"slow; agile", "set4":"slow; clumsy"},
{"categoryID":9,"animal":"cheetah", "alternative":"jaguar", "animalType":"alt", "f1":"fast", "f2":"agile","determiner":"a", "set1":"fast; agile", "set2":"fast; clumsy", "set3":"slow; agile", "set4":"slow; clumsy"},
{"categoryID":10,"animal":"turtle", "alternative":"turtle", "animalType":"orig", "f1":"slow", "f2":"strong","determiner":"a", "set1":"slow; strong", "set2":"slow; weak", "set3":"fast; strong", "set4":"fast; weak"},
{"categoryID":10,"animal":"turtle", "alternative":"turtle", "animalType":"alt", "f1":"slow", "f2":"strong","determiner":"a", "set1":"slow; strong", "set2":"slow; weak", "set3":"fast; strong", "set4":"fast; weak"},
{"categoryID":11,"animal":"lion", "alternative":"lion", "animalType":"orig", "f1":"fierce", "f2":"strong","determiner":"a", "set1":"fierce; strong", "set2":"fierce; weak", "set3":"gentle; strong", "set4":"gentle; weak"},
{"categoryID":11,"animal":"lion", "alternative":"horse", "animalType":"alt", "f1":"fierce", "f2":"strong","determiner":"a", "set1":"fierce; strong", "set2":"fierce; weak", "set3":"gentle; strong", "set4":"gentle; weak"},
{"categoryID":12,"animal":"rabbit", "alternative":"rabbit", "animalType":"orig", "f1":"fast", "f2":"cute","determiner":"a", "set1":"fast; cute", "set2":"fast; ugly", "set3":"slow; cute", "set4":"slow; ugly"},
{"categoryID":12,"animal":"rabbit", "alternative":"jaguar", "animalType":"alt", "f1":"fast", "f2":"cute","determiner":"a", "set1":"fast; cute", "set2":"fast; ugly", "set3":"slow; cute", "set4":"slow; ugly"},

   ]),
    present_handle : function(stim) {
      $(".err").hide();
      this.stim = stim; //FRED: allows you to access stim in helpers

      this.setNums = _.shuffle([1, 2, 3, 4]);
      this.categoryID = stim.categoryID;
      this.animal = stim.animal;
      this.determiner = stim.determiner;
      this.alternative = stim.alternative;
      this.f1 = stim.f1;
      this.f2 = stim.f2;
      this.animalType = stim.animalType;
      this.set1 = stim.set1;
      this.set2 = stim.set2;
      this.set3 = stim.set3;
      this.set4 = stim.set4;

      this.QUD = QUDs.shift();
      this.utteranceType = utteranceTypes.shift();
      var question;
      if (this.QUD==="f1") {
        question = "Is he " + this.f1;
      } else if (this.QUD==="f2") {
        question = "Is he " + this.f2;
      } else {
        question = "What's he like";
      }

      var utterance;
      if (this.utteranceType === "lit") {
        if (this.QUD==="gen") {
          utterance = "He's " + this.f1;
        } else {
          utterance = "Yes, he is";
        }
      } else {
        utterance = "He's " + this.determiner + " " + this.alternative;
      }
      /*
      var sets = {
        "generic": stim.critter + " have " + stim.property + ".",
        "negation": stim.critter + " do not have " + stim.property + ".",
        "always": stim.critter + " always have " + stim.property + ".",
        "sometimes": stim.critter + " sometimes have " + stim.property + ".",
        "usually": stim.critter + " usually have " + stim.property + "."
      };
      */
      $("#det").html(this.determiner);
      $("#animal").html(this.animal);
      $("#question").html(question);
      $("#utterance").html(utterance);
      var name = names.shift();
      $(".speaker").html(name);
      this.n_sliders = this.setNums.length;
      $(".slider_row").remove();
      for (var i=0; i<this.n_sliders; i++) {
        var setNum = this.setNums[i];
        if (setNum === 1) {
          this.featureSet = this.set1;
        } else if (setNum === 2) {
          this.featureSet = this.set2;
        } else if (setNum === 3) {
          this.featureSet = this.set3;
        } else {
          this.featureSet = this.set4;
        }
        //var sentence = sentences[sentence_type];
        $("#multi_slider_table").append('<tr class="slider_row"><td class="slider_target" id="set' + i + '">' + this.featureSet + '</td><td colspan="2"><div id="slider' + i + '" class="slider">-------[ ]--------</div></td></tr>');
        utils.match_row_height("#multi_slider_table", ".slider_target");
      }

      this.init_sliders(this.setNums);
      exp.sliderPost = [];
    },

    button : function() {
      if (exp.sliderPost.length < this.n_sliders || !properArray(exp.sliderPost)) {
        $(".err").show();
      } else {
        this.log_responses();
        _stream.apply(this); //use _stream.apply(this); if and only if there is "present" data.
      }
    },

    init_sliders : function(setNums) {
      for (var i=0; i<setNums.length; i++) {
        var setNum = setNums[i];
        utils.make_slider("#slider" + i, this.make_slider_callback(i));
      }
    },
    make_slider_callback : function(i) {
      return function(event, ui) {
        exp.sliderPost[i] = ui.value;
      };
    },
    log_responses : function() {
      for (var i=0; i<this.setNums.length; i++) {
        var setNum = this.setNums[i];
        var featureSet;
        if (setNum === 1) {
          featureSet = this.set1;
        } else if (setNum === 2) {
          featureSet = this.set2;
        } else if (setNum === 3) {
          featureSet = this.set3;
        } else {
          featureSet = this.set4;
        }
        exp.data_trials.push({
          //"trial_type" : "multi_slider",
          "categoryID" : this.categoryID,
          "animal" : this.animal,
          "alterantive" : this.alternative,
          "animalType" : this.animalType,
          "QUD" : this.QUD,
          "utteranceType" : this.utteranceType,
          "setNum" : setNum,
          "featureSet" : featureSet,
          "response" : exp.sliderPost[i]
        });
      }
    },
  });

  slides.vertical_sliders = slide({
    name : "vertical_sliders",
    present : _.shuffle([
      {
        "bins" : [
          {
            "min" : 0,
            "max" : 10
          },
          {
            "min" : 10,
            "max" : 20
          },
          {
            "min" : 20,
            "max" : 30
          },
          {
            "min" : 30,
            "max" : 40
          },
          {
            "min" : 40,
            "max" : 50
          },
          {
            "min" : 50,
            "max" : 60
          }
        ],
        "question": "How tall is tall?"
      }
    ]),
    present_handle : function(stim) {
      $(".err").hide();
      this.stim = stim;

      $("#vertical_question").html(stim.question);
      
      $("#sliders").empty();
      $("#bin_labels").empty();

      $("#sliders").append('<td> \
            <div id="slider_endpoint_labels"> \
              <div class="top">likely</div> \
              <div class="bottom">unlikely</div>\
            </div>\
          </td>')
      $("#bin_labels").append('<td></td>')

      this.n_sliders = stims.bins.length;
      for (var i=0; i<stim.bins.length; i++) {
        $("#sliders").append("<td><div id='vslider" + i + "' class='vertical_slider'>|</div></td>");
        $("#bin_labels").append("<td class='bin_label'>" + stim.bins[i].min + " - " + stim.bins[i].max + "</td>");
      }

      this.init_sliders(stim);
      exp.sliderPost = [];
    },

    button : function() {
      if (exp.sliderPost.length < this.n_sliders) {
        $(".err").show();
      } else {
        this.log_responses();
        _stream.apply(this); //use _stream.apply(this); if and only if there is "present" data.
      }
    },

    init_sliders : function(stim) {
      for (var i=0; i<stim.bins.length; i++) {
        utils.make_slider("#vslider" + i, this.make_slider_callback(i), "vertical");
      }
    },
    make_slider_callback : function(i) {
      return function(event, ui) {
        exp.sliderPost[i] = ui.value;
      };
    },
    log_responses : function() {
      for (var i=0; i<this.stim.bins.length; i++) {
        exp.data_trials.push({
          "trial_type" : "vertical_slider",
          "question" : this.stim.question,
          "response" : exp.sliderPost[i],
          "min" : this.stim.bins[i].min,
          "max" : this.stim.bins[i].max
        });
      }
    },
  });

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        enjoyment : $("#enjoyment").val(),
        asses : $('input[name="assess"]:checked').val(),
        age : $("#age").val(),
        gender : $("#gender").val(),
        education : $("#education").val(),
        comments : $("#comments").val(),
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          "condition" : exp.condition,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {
  repeatWorker = false;
  (function(){
      var ut_id = "jtk-metset-2-20160204";
      if (UTWorkerLimitReached(ut_id)) {
        $('.slide').empty();
        repeatWorker = true;
        alert("You have already completed the maximum number of HITs allowed by this requester. Please click 'Return HIT' to avoid any impact on your approval rating.");
      }
  })();
  exp.trials = [];
  exp.catch_trials = [];
  exp.condition = _.sample(["CONDITION 1", "condition 2"]); //can randomize between subject conditions here
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
  //blocks of the experiment:
  exp.structure=["i0", "multi_slider", 'subj_info', 'thanks'];
  
  exp.data_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function() {$("#mustaccept").show();});
      exp.go();
    }
  });

  exp.go(); //show first slide
}