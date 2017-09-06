# option_call_signal
Signal generator for trading options

The strategy is as follows:
  check for stocks that have dropped 3-4% below their 60 day average
  run monte carlo simulation and check to see if they are expected to reach the 60 day average within the next three months
  if they are, buy the call with a strike price of the 60 day average 4 months out
