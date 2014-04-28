$(function () {
  $('#words-frequency-visualization').words_mentions({
    images: {
      "V. Filat": "images/filat.png"
    , "V. Voronin": "images/voronin.png"
    , "A. Tănase": "images/tanase.png"
    , "I. Dodon": "images/dodon.png"
    , "M. Ghimpu": "images/ghimpu.png"
    , "S. Urechean": "images/urechean.png"
    , "M. Lupu": "images/lupu.png"
    , "I. Leancă": "images/leanca.png"
    , "V. Plahotniuc": "images/plahotniuc.png"
    , "D. Chirtoacă": "images/chirtoaca.png"
    , "M. Godea": "images/godea.png"
    , "D. Diacov": "images/diacov.png"
    , "V. Streleţ": "images/strelet.png"
    , "S. Sârbu": "images/sarbu.png"
    , "I. Hadârcă": "images/hadarca.png"
    }
  , data_source: 'data/dataset.json'
  , rounding_function: function(a) {return Math.round(parseFloat(a)*100)/100} // rounding by 2 decimals after point
  , text_months_size: '12px'
  })
});
