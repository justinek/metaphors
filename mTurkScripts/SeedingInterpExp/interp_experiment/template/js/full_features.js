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
      {"animalID": 1, "animal": "ant", "features": ["funny","industrious","busy","quiet","small","smart"], "numFeatures": 6}, 
      {"animalID": 2, "animal": "whale", "features": ["hard","big","proud","fast","fierce","majestic","strong"], "numFeatures": 7}, 
      {"animalID": 3, "animal": "bird", "features": ["industrious","agile","quiet","fast","sleek","small"], "numFeatures": 6}, 
      {"animalID": 4, "animal": "elephant", "features": ["majestic","big","slow","hard","strong"], "numFeatures": 5}, 
      {"animalID": 5, "animal": "panda", "features": ["cute","lazy","big","hard","playful","loyal","majestic","friendly"], "numFeatures": 8}, 
      {"animalID": 6, "animal": "monkey", "features": ["funny","lazy","cute","loyal","loud","friendly","smart","happy"], "numFeatures": 8}, 
      {"animalID": 7, "animal": "penguin", "features": ["funny","lazy","cute","playful","loyal","loud","friendly","smart"], "numFeatures": 8}, 
      {"animalID": 8, "animal": "giraffe", "features": ["slithery","tall","strong","long","fast"], "numFeatures": 5}, 
      {"animalID": 9, "animal": "cheetah", "features": ["funny","lazy","cute","agile","fast","sleek","dumb","smart"], "numFeatures": 8}, 
      {"animalID": 10, "animal": "turtle", "features": ["hairy","lazy","slow","big","hard","fast","strong"], "numFeatures": 7}, 
      {"animalID": 11, "animal": "lion", "features": ["hairy","big","hard","fast","fierce","striped","strong"], "numFeatures": 7}, 
      {"animalID": 12, "animal": "rabbit", "features": ["cute","lazy","agile","fast","sleek","playful","loyal","friendly"], "numFeatures": 8}, 
      /*
      {"animalID": 13, "animal": "mouse", "features": ["small","lazy","industrious","quiet","cute"], "numFeatures": 5}, 
      {"animalID": 14, "animal": "beaver", "features": ["funny","industrious","busy","fast","small","smart"], "numFeatures": 6}, 
      {"animalID": 15, "animal": "horse", "features": ["hairy","big","hard","fast","sleek","agile","strong"], "numFeatures": 7}, 
      {"animalID": 16, "animal": "eagle", "features": ["cute","lazy","proud","fast","fierce","majestic","strong"], "numFeatures": 7}, 
      {"animalID": 17, "animal": "jaguar", "features": ["happy","lazy","cute","agile","fast","sleek","slimy","slippery","long","slithery","strong","smart","scaly"], "numFeatures": 13}, 
      {"animalID": 18, "animal": "armadillo", "features": ["lazy","slow","hard","strong"], "numFeatures": 4}, 
      {"animalID": 19, "animal": "cat", "features": ["cute","lazy","slow","playful","loyal","friendly"], "numFeatures": 6}, 
      {"animalID": 20, "animal": "dog", "features": ["lazy","cute","loyal","friendly"], "numFeatures": 4}, 
      {"animalID": 21, "animal": "kitten", "features": ["playful","cute","loyal","lazy","friendly"], "numFeatures": 5}, 
      {"animalID": 22, "animal": "hyena", "features": ["funny","lazy","cute","fast","small","loyal","fierce","strong","loud","friendly","smart"], "numFeatures": 11}, 
      {"animalID": 23, "animal": "dolphin", "features": ["fast","loyal","small","friendly","smart","happy"], "numFeatures": 6}, 
      {"animalID": 24, "animal": "snake", "features": ["slithery","tall","lazy","slow","long"], "numFeatures": 5}, 
      {"animalID": 25, "animal": "deer", "features": ["stubborn","lazy","slow","cute","big","quiet","fast","sleek","loyal","dumb","fat","agile","small","strong","friendly","dirty"], "numFeatures": 16}, 
      {"animalID": 26, "animal": "sloth", "features": ["cute","lazy","slow","strong"], "numFeatures": 4}, 
      {"animalID": 27, "animal": "gorilla", "features": ["hairy","funny","lazy","cute","big","hard","majestic","strong","smart"], "numFeatures": 9}, 
      {"animalID": 28, "animal": "bear", "features": ["hairy","big","hard","fast","majestic","strong"], "numFeatures": 6}, 
      {"animalID": 29, "animal": "tiger", "features": ["fierce","striped","strong","fast"], "numFeatures": 4}, 
      {"animalID": 30, "animal": "bee", "features": ["industrious","busy","agile","fast","sleek","small"], "numFeatures": 6}, 
      {"animalID": 31, "animal": "eel", "features": ["slimy","slippery"], "numFeatures": 2}, 
      {"animalID": 32, "animal": "cougar", "features": ["happy","lazy","cute","agile","fast","sleek","slimy","slippery","long","slithery","strong","smart","scaly"], "numFeatures": 13}, 
      {"animalID": 33, "animal": "fish", "features": ["slimy","scaly"], "numFeatures": 2}, 
      {"animalID": 34, "animal": "donkey", "features": ["stubborn","lazy","slow","strong"], "numFeatures": 4}, 
      {"animalID": 35, "animal": "cow", "features": ["majestic","big","hard","fat"], "numFeatures": 4}, 
      {"animalID": 36, "animal": "hippo", "features": ["majestic","big","hard","fat"], "numFeatures": 4}, 
      {"animalID": 37, "animal": "mule", "features": ["stubborn","lazy","slow","strong"], "numFeatures": 4}, 
      {"animalID": 38, "animal": "pig", "features": ["dirty","fat"], "numFeatures": 2}, 
      {"animalID": 39, "animal": "zebra", "features": ["fierce","agile","striped","fast","sleek"], "numFeatures": 5}, 
      */
      ]).slice(0,10),
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

        this.n_sliders = stim.numFeatures;
        $(".slider_row").remove();
        this.animalID = stim.animalID;
        this.animal = stim.animal;
        this.features = _.shuffle(stim.features);
        var name = names.shift();
        $("#name1").html(name);
        $("#name2").html(name);
  
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

        this.init_sliders(this.features);
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
        for (var i=0; i<this.features.length; i++) {
          var feature = this.features[i];
          exp.data_trials.push({
            "trial_type" : "multi_slider",
            "animalID" : this.animalID,
            "animal" : this.animal,
            "feature" : feature,
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