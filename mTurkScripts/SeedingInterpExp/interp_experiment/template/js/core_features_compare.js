var names = _.shuffle(["Alex", "Bob", "Calvin", "David", "Eric", "Frank", "George", 
  "Harry", "Ivan", "Jake", "Kenneth", "Luke", "Matt", "Nathan", "Owen",
  "Patrick", "Quinn", "Robert", "Steve", "Tom", "Victor", 
  "Winston", "Zach", "Albert", "Barry", "Charles", "Daniel", "Ethan", "Fred", "Gary", "Henry",
  "Jeff"]);


function addDeterminer(word) {
  var vowels = ['a', 'e', 'i', 'o', 'u'];
  if (vowels.indexOf(word.charAt(0)) >= 0) {
    return 'an ' + word;
  } else {
    return 'a ' + word;
  }
}

function properArray(array) {
  for (var i=0; i < array.length; i++) {
    if (typeof array[i] == "undefined") {
      return false;
    }
    return true;
  }
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
    {"animalID": 1, "animal": "ant", "feature": "small", "alternatives": ["turtle","hippo","donkey","bee","jaguar","monkey","cow","dolphin","deer","dog","pig","hyena","ant","lion","cat","cheetah","beaver","mule","mouse","bird","man"], "numAlts":21, "superlative": "smallest"}, 
{"animalID": 1, "animal": "ant", "feature": "industrious", "alternatives": ["jaguar","monkey","cat","ant","beaver","cheetah","bee","mouse","bird","man"], "numAlts":10, "superlative": "most industrious"}, 
{"animalID": 2, "animal": "whale", "feature": "big", "alternatives": ["turtle","sloth","donkey","eagle","deer","pig","lion","mouse","panda","horse","monkey","elephant","cheetah","bird","hippo","bear","mule","tiger","armadillo","kitten","whale","man","jaguar","cow","dog","cat","gorilla"], "numAlts":27, "superlative": "biggest"}, 
{"animalID": 2, "animal": "whale", "feature": "majestic", "alternatives": ["turtle","eagle","horse","monkey","cow","hippo","elephant","dog","bear","cat","gorilla","lion","armadillo","kitten","whale","panda","man"], "numAlts":17, "superlative": "most majestic"}, 
{"animalID": 3, "animal": "bird", "feature": "fast", "alternatives": ["turtle","sloth","donkey","eagle","fish","dolphin","deer","pig","ant","lion","zebra","beaver","cat","mouse","horse","monkey","eel","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","giraffe","snake","rabbit","kitten","whale","man","jaguar","cow","dog","bee","hyena","gorilla"], "numAlts":37, "superlative": "fastest"}, 
{"animalID": 3, "animal": "bird", "feature": "small", "alternatives": ["turtle","hippo","donkey","bee","jaguar","monkey","cow","dolphin","deer","dog","pig","hyena","ant","lion","cat","cheetah","beaver","mule","mouse","bird","man"], "numAlts":21, "superlative": "smallest"}, 
{"animalID": 4, "animal": "elephant", "feature": "big", "alternatives": ["turtle","sloth","donkey","eagle","deer","pig","lion","mouse","panda","horse","monkey","elephant","cheetah","bird","hippo","bear","mule","tiger","armadillo","kitten","whale","man","jaguar","cow","dog","cat","gorilla"], "numAlts":27, "superlative": "biggest"}, 
{"animalID": 4, "animal": "elephant", "feature": "hard", "alternatives": ["turtle","eagle","horse","jaguar","monkey","cow","sloth","kitten","dog","bear","cat","tiger","gorilla","lion","armadillo","hippo","elephant","cheetah","whale","panda","man"], "numAlts":21, "superlative": "hardest"}, 
{"animalID": 5, "animal": "panda", "feature": "cute", "alternatives": ["turtle","sloth","donkey","hippo","fish","dolphin","deer","pig","ant","lion","mouse","panda","horse","monkey","eel","cougar","elephant","cheetah","man","bird","eagle","bear","mule","snake","rabbit","kitten","whale","penguin","jaguar","cow","dog","cat","hyena","gorilla"], "numAlts":34, "superlative": "cutest"}, 
{"animalID": 5, "animal": "panda", "feature": "big", "alternatives": ["turtle","sloth","donkey","eagle","deer","pig","lion","mouse","panda","horse","monkey","elephant","cheetah","bird","hippo","bear","mule","tiger","armadillo","kitten","whale","man","jaguar","cow","dog","cat","gorilla"], "numAlts":27, "superlative": "biggest"}, 
{"animalID": 6, "animal": "monkey", "feature": "funny", "alternatives": ["beaver","ant","penguin","jaguar","monkey","dolphin","deer","dog","bear","bee","hyena","gorilla","lion","kitten","cheetah","whale","cat","mouse","bird","elephant","man"], "numAlts":21, "superlative": "funniest"}, 
{"animalID": 6, "animal": "monkey", "feature": "smart", "alternatives": ["fish","dolphin","deer","ant","lion","beaver","bee","mouse","horse","monkey","eel","cougar","elephant","cheetah","man","bird","bear","snake","kitten","whale","penguin","jaguar","dog","cat","hyena","gorilla"], "numAlts":26, "superlative": "smartest"}, 
{"animalID": 7, "animal": "penguin", "feature": "funny", "alternatives": ["beaver","ant","penguin","jaguar","monkey","dolphin","deer","dog","bear","bee","hyena","gorilla","lion","kitten","cheetah","whale","cat","mouse","bird","elephant","man"], "numAlts":21, "superlative": "funniest"}, 
{"animalID": 7, "animal": "penguin", "feature": "cute", "alternatives": ["turtle","sloth","donkey","hippo","fish","dolphin","deer","pig","ant","lion","mouse","panda","horse","monkey","eel","cougar","elephant","cheetah","man","bird","eagle","bear","mule","snake","rabbit","kitten","whale","penguin","jaguar","cow","dog","cat","hyena","gorilla"], "numAlts":34, "superlative": "cutest"}, 
{"animalID": 8, "animal": "giraffe", "feature": "tall", "alternatives": ["sloth","horse","giraffe","snake","man"], "numAlts":5, "superlative": "tallest"}, 
{"animalID": 8, "animal": "giraffe", "feature": "long", "alternatives": ["sloth","horse","jaguar","eel","fish","dolphin","cat","cougar","giraffe","snake","cheetah","man"], "numAlts":12, "superlative": "longest"}, 
{"animalID": 9, "animal": "cheetah", "feature": "fast", "alternatives": ["turtle","sloth","donkey","eagle","fish","dolphin","deer","pig","ant","lion","zebra","beaver","cat","mouse","horse","monkey","eel","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","giraffe","snake","rabbit","kitten","whale","man","jaguar","cow","dog","bee","hyena","gorilla"], "numAlts":37, "superlative": "fastest"}, 
{"animalID": 9, "animal": "cheetah", "feature": "agile", "alternatives": ["turtle","donkey","fish","dolphin","deer","pig","ant","zebra","beaver","bee","mouse","horse","monkey","gorilla","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","snake","rabbit","kitten","man","jaguar","cow","dog","cat","eel"], "numAlts":31, "superlative": "most agile"}, 
{"animalID": 10, "animal": "turtle", "feature": "slow", "alternatives": ["turtle","sloth","donkey","deer","pig","mouse","horse","elephant","cheetah","bird","hippo","bear","mule","giraffe","armadillo","snake","kitten","whale","man","jaguar","cow","dog","cat","gorilla"], "numAlts":24, "superlative": "slowest"}, 
{"animalID": 10, "animal": "turtle", "feature": "strong", "alternatives": ["turtle","sloth","donkey","eagle","fish","dolphin","deer","pig","lion","zebra","mouse","horse","monkey","eel","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","giraffe","armadillo","snake","whale","man","jaguar","cow","dog","cat","hyena","gorilla"], "numAlts":33, "superlative": "strongest"}, 
{"animalID": 11, "animal": "lion", "feature": "fierce", "alternatives": ["eagle","horse","jaguar","monkey","dog","bear","cat","tiger","gorilla","lion","zebra","hyena","elephant","cheetah","whale","bird","man"], "numAlts":17, "superlative": "fiercest"}, 
{"animalID": 11, "animal": "lion", "feature": "strong", "alternatives": ["turtle","sloth","donkey","eagle","fish","dolphin","deer","pig","lion","zebra","mouse","horse","monkey","eel","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","giraffe","armadillo","snake","whale","man","jaguar","cow","dog","cat","hyena","gorilla"], "numAlts":33, "superlative": "strongest"}, 
{"animalID": 12, "animal": "rabbit", "feature": "fast", "alternatives": ["turtle","sloth","donkey","eagle","fish","dolphin","deer","pig","ant","lion","zebra","beaver","cat","mouse","horse","monkey","eel","cougar","elephant","cheetah","bird","hippo","bear","mule","tiger","giraffe","snake","rabbit","kitten","whale","man","jaguar","cow","dog","bee","hyena","gorilla"], "numAlts":37, "superlative": "fastest"}, 
{"animalID": 12, "animal": "rabbit", "feature": "cute", "alternatives": ["turtle","sloth","donkey","hippo","fish","dolphin","deer","pig","ant","lion","mouse","panda","horse","monkey","eel","cougar","elephant","cheetah","man","bird","eagle","bear","mule","snake","rabbit","kitten","whale","penguin","jaguar","cow","dog","cat","hyena","gorilla"], "numAlts":34, "superlative": "cutest"}, 

    ]).slice(0,6),
present_handle : function(stim) {
  $(".err").hide();
        this.stim = stim; //FRED: allows you to access stim in helpers

  /*
        this.sentence_types = _.shuffle(["generic", "negation", "always", "sometimes", "usually"]);
        var sentences = {
          "generic": stim.critter + " have " + stim.property + ".",
          "negation": stim.critter + " do not have " + stim.property + ".",
          "always": stim.critter + " always have " + stim.property + ".",
          "sometimes": stim.critter + " sometimes have " + stim.property + ".",
          "usually": stim.critter + " usually have " + stim.property + "."
        };
        */

        this.n_sliders = stim.numAlts;
        $(".slider_row").remove();
        this.animalID = stim.animalID;
        this.animal = stim.animal;
        this.feature = stim.feature;
        var name = names.shift();
        $("#name1").html(name);
        $("#name2").html(name);
        $("#sentence").html(addDeterminer(this.animal));

        
        this.alternatives = _.shuffle(stim.alternatives);
        this.superlative = stim.superlative;
        $("#feature").html(this.feature);
        $("#low").html(this.feature);
        $("#high").html(this.superlative);
        for (var i=0; i<this.n_sliders; i++) {
          if (this.alternatives[i] === "man") {
            var sentence = "the man " + name + " works with";
          } else {
            var sentence = addDeterminer(this.alternatives[i]);
          }
          $("#multi_slider_table").append('<tr class="slider_row"><td class="slider_target" id="animal' + i + '">' + sentence + '</td><td colspan="2"><div id="slider' + i + '" class="slider">-------[ ]--------</div></td></tr>');
          utils.match_row_height("#multi_slider_table", ".slider_target");
        }

        /*
        var sentence = addDeterminer(this.animal);
        $("#sentence").html(sentence);
        for (var i=0; i<this.n_sliders; i++) {
          var feature = this.features[i];
          $("#low").html(feature);
          $("#high").html(feature);
          var question = "</br>How <i><b>" + feature + "</b></i> is the man?";
          
          //var sentence = addDeterminer(this.animal[i]);
          $("#multi_slider_table").append('<tr class="slider_row" align="center"><td colspan=4>' + question + '</td></tr>');
          $("#multi_slider_table").append('<tr class="slider_row"><td class="slider_target" id="feature' + i + '"> the least ' + feature + ' thing on the planet</td><td colspan="2"><div id="slider' + i + '" class="slider">-------[ ]--------</div></td><td> the most ' + feature + ' thing on the planet</td></tr>');
          
          utils.match_row_height("#multi_slider_table", ".slider_target");
        }
        */

        this.init_sliders(this.alternatives);
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

      init_sliders : function(sentence_types) {
        for (var i=0; i<sentence_types.length; i++) {
          var sentence_type = sentence_types[i];
          utils.make_slider("#slider" + i, this.make_slider_callback(i));
        }
      },
      make_slider_callback : function(i) {
        return function(event, ui) {
          exp.sliderPost[i] = ui.value;
        };
      },
      log_responses : function() {
        for (var i=0; i<this.alternatives.length; i++) {
          var alternative = this.alternatives[i];
          exp.data_trials.push({
            "trial_type" : "multi_slider",
            "animalID" : this.animalID,
            "animal" : this.animal,
            "feature" : this.feature,
            "alternative" : alternative,
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

    var bin_labels = "<td></td>";
    var sliders_and_top_label = "<td class='thin'>likely</td>";
    for (var i=0; i<stim.bins.length; i++) {
      bin_labels += "<td class='bin_label'>" + stim.bins[i].min + " - " + stim.bins[i].max + "</td>";
      sliders_and_top_label += "<td rowspan='3'><div id='vslider" + i + "' class='vertical_slider'>|</div></td>";
    }
    $("#sliders_and_top_label").html(sliders_and_top_label);
    $("#bin_labels").html(bin_labels);

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
    exp.trials = [];
    exp.catch_trials = [];
    exp.condition = _.sample(["condition 1", "condition 2"]); //can randomize between subject conditions here
    exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
    //blocks of the experiment:
    exp.structure=["i0", "instructions", "multi_slider", 'subj_info', 'thanks'];
    
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