Sinatra
=============

Brought to you by Lighthouse Labs

## Getting Started

1. `bundle install`
2. `shotgun -p 3000 -o 0.0.0.0`
3. Visit `http://localhost:3000/` in your browser

Shotgun: shotgun -p 3000 -o 0.0.0.0
Average Total time of one jquery post request is: 630 ms
Average Total time of the move function is: 80 ms
Average Total time of sending divs (vs empty string) is: 20ms
Shotgun operation time: 630 - 80 - 20 = 530 ms

Thin: thin start -p 3000
Average Total time of one jquery post request is: 40 ms
Average Total time of the move function is: 15 ms
Average Total time of sending divs (vs empty string) is: 20ms
Thin operation time: 40 - 15 - 20 = 5 ms
