#' Plays jingle bells!
#' 
#' @param vol The audio volume, from 0 (silent) to 1 (loud)
#' 
#' @import dplyr
#' @import audio
#' @importFrom magrittr `%>%`
#' 
#' @author Ben Cuff

#'@export
jingle_bells <- function(vol=0.1){

  notes <- c(A = 0, B = 2, C = 3, D = 5, E = 7, F = 8, G = 10)
  
  pitch <- paste("E E E",
                 "E E E",
                 "E G C D",
                 "E",
                 "F F F F",
                 "F E E E",
                 "E D D E",
                 "D G",
                 "E E E",
                 "E E E",
                 "E G C D",
                 "E",
                 "F F F F",
                 "F E E E E",
                 "G G F D",
                 "C",
                 "G3 E D C",
                 "G3",
                 "G3 G3 G3 E D C",
                 "A3",
                 "A3 F E D",
                 "B3",
                 "G G F D",
                 "E",
                 "G3 E D C",
                 "G3",
                 "G3 E D C",
                 "A3 A3",
                 "A3 F E D",
                 "G G G G A G F D",
                 "C C5 B A G F G",
                 "E E E G C D",
                 "E E E G C D",
                 "E F G A C E D F",
                 "E C D E F G A G",
                 "F F F F F F",
                 "F E E E E E",
                 "E D D D D E",
                 "D D E F G F E D",
                 "E E E G C D",
                 "E E E G C D",
                 "E F G A C E D F",
                 "E C D E F G A G",
                 "F F F F F F",
                 "F E E E E E",
                 "G C5 B A G F E D",
                 "C C E G C5")
  
  duration <- c(1, 1, 2,
                1, 1, 2,
                1, 1, 1.5, 0.5,
                4,
                1, 1, 1, 1,
                1, 1, 1, 1,
                1, 1, 1, 1,
                2, 2,
                1, 1, 2,
                1, 1, 2,
                1, 1, 1.5, 0.5,
                4,
                1, 1, 1, 1,
                1, 1, 1, 0.5, 0.5,
                1, 1, 1, 1,
                4,
                1, 1, 1, 1,
                3, .5, .5,
                1, 1, 1, 1,
                4,
                1, 1, 1, 1,
                4,
                1, 1, 1, 1,
                4,
                1, 1, 1, 1,
                4,
                1, 1, 1, 1,
                3, 1,
                1, 1, 1, 1,
                1, 1, 1, 1,
                1, 1, 1, 1,
                1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
                1, 1, 0.5, 0.5, 0.5, 0.5,
                1, 1, 0.5, 0.5, 0.5, 0.5,
                0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
                0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
                1, 0.5, 0.5, 1, 0.5, 0.5,
                1, 0.5, 0.5, 1, 0.5, 0.5,
                1, 0.5, 0.5, 0.5, 0.5, 1,
                1, 0.33, 0.33, 0.33, 1, 0.33, 0.33, 0.33,
                1, 1, 0.5, 0.5, 0.5, 0.5,
                1, 1, 0.5, 0.5, 0.5, 0.5,
                0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
                0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
                1, 0.5, 0.5, 1, 0.5, 0.5,
                1, 0.5, 0.5, 1, 0.5, 0.5,
                0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
                1, 0.33, 0.33, 0.33, 2)
  
  jbells <- data.frame(pitch = strsplit(pitch, " ")[[1]],
                       duration = duration)
  
  jbells <- jbells %>%
    mutate(octave = substring(pitch, nchar(pitch)) %>%
             {suppressWarnings(as.numeric(.))} %>%
             ifelse(is.na(.), 4, .),
           note = notes[substr(pitch, 1, 1)],
           note = note + grepl("#", pitch) -
             grepl("b", pitch) + octave * 12 +
             12 * (note < 3),
           freq = 2 ^ ((note - 60) / 12) * 440)
  
  tempo <- 250
  
  sample_rate <- 44100
  
  make_sine <- function(freq, duration) {
    wave <- sin(seq(0, duration / tempo * 60, 1 / sample_rate) *
                  freq * 2 * pi)
    fade <- seq(0, 1, 50 / sample_rate)
    wave * c(fade, rep(1, length(wave) - 2 * length(fade)), rev(fade))
  }
  
  jbells_wave <- mapply(make_sine, jbells$freq, jbells$duration) %>%
    do.call("c", .)
  
  jbells_wave_volume_adjusted = jbells_wave * vol
  
  play(jbells_wave_volume_adjusted)
  
  print("Merry Christmas!")
}