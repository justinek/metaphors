var names = _.shuffle(["Alex", "Bob", "Calvin", "David", "Eric", "Frank", "George", 
  "Harry", "Ivan", "Jake", "Kenneth", "Luke", "Matt", "Nathan", "Owen",
  "Patrick", "Quinn", "Robert", "Steve", "Tom", "Victor", 
  "Winston", "Zach", "Albert", "Barry", "Charles", "Daniel", "Ethan", "Fred", "Gary", "Henry",
  "Jeff"]);

var numTrials = 3;


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
{"animalID": 1, "animal": "ant", "coreFeatures": ["small","industrious"], "features": ["funny","industrious","busy","quiet","small","smart"], "alternatives": ["ant","beaver","mouse","monkey","man", "average man"]}, 
{"animalID": 2, "animal": "whale", "coreFeatures": ["big","majestic"], "features": ["hard","big","proud","fast","fierce","majestic","strong"], "alternatives": ["eagle","whale","horse","lion","elephant","man", "average man"]}, 
{"animalID": 3, "animal": "bird", "coreFeatures": ["fast","small"], "features": ["industrious","agile","quiet","fast","sleek","small"], "alternatives": ["ant","cheetah","mouse","jaguar","bird","man", "average man"]}, 
{"animalID": 4, "animal": "elephant", "coreFeatures": ["big","hard"], "features": ["majestic","big","slow","hard","strong"], "alternatives": ["turtle","whale","armadillo","elephant","man", "average man"]}, 
/*
{"animalID": 5, "animal": "panda", "coreFeatures": ["cute","big"], "features": ["cute","lazy","big","hard","playful","loyal","majestic","friendly"], "alternatives": ["elephant","dog","cat","kitten","whale","panda","man", "average man"]}, 
{"animalID": 6, "animal": "monkey", "coreFeatures": ["funny","smart"], "features": ["funny","lazy","cute","loyal","loud","friendly","smart","happy"], "alternatives": ["hyena","dog","dolphin","monkey","cat","man", "average man"]}, 
{"animalID": 7, "animal": "penguin", "coreFeatures": ["funny","cute"], "features": ["funny","lazy","cute","playful","loyal","loud","friendly","smart"], "alternatives": ["monkey","dog","cat","hyena","kitten","penguin","man", "average man"]}, 
{"animalID": 8, "animal": "giraffe", "coreFeatures": ["tall","long"], "features": ["slithery","tall","strong","long","fast"], "alternatives": ["horse","giraffe","snake","man", "average man"]}, 
{"animalID": 9, "animal": "cheetah", "coreFeatures": ["fast","agile"], "features": ["funny","lazy","cute","agile","fast","sleek","dumb","smart"], "alternatives": ["cheetah","deer","jaguar","monkey","cat","man", "average man"]}, 
{"animalID": 10, "animal": "turtle", "coreFeatures": ["slow","strong"], "features": ["hairy","lazy","slow","big","hard","fast","strong"], "alternatives": ["turtle","sloth","horse","bear","gorilla","elephant","man", "average man"]}, 
{"animalID": 11, "animal": "lion", "coreFeatures": ["fierce","strong"], "features": ["hairy","big","hard","fast","fierce","striped","strong"], "alternatives": ["horse","bear","tiger","gorilla","lion","elephant","man", "average man"]}, 
{"animalID": 12, "animal": "rabbit", "coreFeatures": ["fast","cute"], "features": ["cute","lazy","agile","fast","sleek","playful","loyal","friendly"], "alternatives": ["jaguar","dog","cat","rabbit","kitten","cheetah","man", "average man"]}, 
*/
]).slice(0,numTrials), // number of itmes to show
present_handle : function(stim) {
  $(".err").hide();
        this.stim = stim; //FRED: allows you to access stim in helpers


        
        $(".slider_row").remove();
        this.animalID = stim.animalID;
        this.animal = stim.animal;
        this.features = _.shuffle(stim.features);
        this.alternatives = _.shuffle(stim.alternatives);
        this.n_features = this.features.length; 
        this.n_alternatives = this.alternatives.length;
        this.n_sliders = this.n_features * this.n_alternatives;
        this.coreFeatures = _.shuffle(stim.coreFeatures);
        this.utteranceType = _.sample(["literal", "figurative"]);
        if (this.utteranceType === "literal") {
          this.utterance = _.sample(this.coreFeatures);
          $("#sentence").html(this.utterance);
        } else {
          this.utterance = this.animal;
          $("#sentence").html(addDeterminer(this.animal));
        }

        var name = names.shift();
        $("#name1").html(name);
        $("#name2").html(name);
        

        

        for (var i=0; i< this.n_features; i++) {
          var feature = this.features[i];
          $("#multi_slider_table").append('<tr class="slider_row"><td><br></td></tr>');
          $("#multi_slider_table").append('<tr class="slider_row" align="center"><td colspan=3><p class="question">Compared to everything else on the planet, how <i><b><span id="feature' + i + '">{{}}</span></b></i> is each of the following?</p></td></tr>');
          $("#feature" + i).html(feature);
          $("#multi_slider_table").append('<tr class="slider_row"><td></td><td class="left">least ' + feature + '</span></td><td class="right">most ' + feature + '</td></tr>');
          for (var j=0; j< this.n_alternatives; j++) {
            var sliderNum = (i * this.n_alternatives) + j;
            if (this.alternatives[j] === "man") {
              var sentence = "the man " + name + " works with";
            } else {
              var sentence = addDeterminer(this.alternatives[j]);
            }
            $("#multi_slider_table").append('<tr class="slider_row"><td class="slider_target" id="num' + sliderNum + '">' + sentence + '</td><td colspan="2"><div id="slider' + sliderNum + '" class="slider">-------[ ]--------</div></td></tr>');
            utils.match_row_height("#multi_slider_table", ".slider_target");
          }
          
        }
        this.init_sliders(this.n_sliders);
       
        exp.sliderPost = [];
        exp.numSliders = this.n_sliders;
      },

      button : function() {
        if (exp.sliderPost.length < this.n_sliders || !properArray(exp.sliderPost)) {
          $(".err").show();
        } else {
          this.log_responses();
          _stream.apply(this); //use _stream.apply(this); if and only if there is "present" data.
        }
      },

      init_sliders : function(numSliders) {
        for (var i=0; i<numSliders; i++) {
          utils.make_slider("#slider" + i, this.make_slider_callback(i));
        //}
        }
      },
      make_slider_callback : function(i) {
        return function(event, ui) {
          exp.sliderPost[i] = ui.value;
        };
      },
      log_responses : function() {
        for (var i=0; i <this.n_features; i++) {
          for (var j=0; j<this.n_alternatives; j++) {
            var feature = this.features[i];
            var alternative = this.alternatives[j];

            exp.data_trials.push({
              "trial_type" : "multi_slider",
              "animalID" : this.animalID,
              "animal" : this.animal,
              "utterance" : this.utterance,
              "utteranceType": this.utteranceType,
              "feature" : feature,
              "alternative" : alternative,
              "response" : exp.sliderPost[i * this.n_alternatives + j]
          });
        }
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
      //"catch_trials" : exp.catch_trials,
      "system" : exp.system,
      //"condition" : exp.condition,
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