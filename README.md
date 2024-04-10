# SSRS-Time-Picker
A SQL stored procedure that can be used to add a "time picker" parameter to Visual Studio SSRS.

Because SSRS doesn't have a default "pick a time" parameter option, I made a stored procedure which you can add as a dataset to reports and use as a time picker (so you don't have to waste time writing in each hour individually in the parameter window).

It provides hours in intervals of 30 minutes (although more intervals can easily be added), and also has two paramters for default start and end times, if you need to set defaults for your parameters; you can set the default start/end times as any hour or half-hour between 00:00 - 23:30 (they default to 12:00 if null) specifically in the 24 hour xx:xx format.

I've provided an example of how to implement the times picked by users in report queries, but this is just one example of how this might be used.
