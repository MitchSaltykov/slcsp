# SLCSP

## Calculate the second lowest cost silver plan

## Problem

You've been asked to determine the second lowest cost silver plan (SLCSP) for
a group of ZIP codes.

## Task

You've been given a CSV file, `slcsp.csv`, which contains the ZIP codes in the
first column. Fill in the second column with the rate (see below) of the
corresponding SLCSP and emit the answer on `stdout` using the same CSV format as
the input. Write your code in your best programming language.

### Expected output

The order of the rows in your answer as emitted on stdout must stay the same as how they
appeared in the original `slcsp.csv`. The first row should be the column headers: `zipcode,rate`
The remaining lines should output unquoted values with two digits after the decimal
place of the rates, for example: `64148,245.20`.

It may not be possible to determine a SLCSP for every ZIP code given; for example, if there is only one silver plan available, there is no _second_ lowest cost plan. Check for cases where a definitive answer cannot be found and leave those cells blank in the output (no quotes or zeroes or other text). For example, `40813,`.

## Additional information

The SLCSP is the so-called "benchmark" health plan in a particular area. It's
used to compute the tax credit that qualifying individuals and families receive
on the marketplace. It's the second lowest rate for a silver plan in the rate area.

For example, if a rate area had silver plans with rates of `[197.3, 197.3, 201.1, 305.4, 306.7, 411.24]`, the SLCSP for that rate area would be `201.1`,
since it's the second lowest rate in that rate area.

A plan has a "metal level", which can be either Bronze, Silver, Gold, Platinum,
or Catastrophic. The metal level is indicative of the level of coverage the plan
provides.

A plan has a "rate", which is the amount that a consumer pays as a monthly
premium, in dollars.

A plan has a "rate area", which is a geographic region in a state that
determines the plan's rate. A rate area is a tuple of a state and a number, for
example, NY 1, IL 14.

There are two additional CSV files in this directory besides `slcsp.csv`:

- `plans.csv` — all the health plans in the U.S. on the marketplace
- `zips.csv` — a mapping of ZIP code to county/counties & rate area(s)

A ZIP code can potentially be in more than one county. If the county can not be
determined definitively by the ZIP code, it may still be possible to determine
the rate area for that ZIP code. A ZIP code can also be in more than one rate area. In that case, the answer is ambiguous
and should be left blank.

We'll want to compile your code from source and run it from a Unix-like command line, so please include the complete instructions for doing so in a COMMENTS file.

## Solution notes

I wrote this in the IntelliJ Community Edition IDE, running on Ruby 3.1.2p20 under Windows WSL Ubuntu.

For a more general command-line solution it could make sense to take the file names as command line arguments via ARGV, but I opted for hardcoding them to make running the solution more straightforward. To run the solution, open a prompt in the directory with the solution script and the CSVs and run:
`ruby -r './slcsp.rb' -e 'SLCSP.process'`
. To check the tests in specs/slcsp_spec.rb, run
`rspec`
.

I noticed that nearly half of the output rows did not have a SLCSP value, which seemed surprising., but they met the criteria in the exercise:
- Several of the zip codes were for states with no data in the plans.csv file provided, like 40813 in KY and 06239 in CT.
- Others had ambiguous state areas like 54923 in WI 13 / WI 11, and 46706 in IN 4 / IN 3.
- Some only had a single rate entry, and therefore no second-lowest rate, like 07184 and 07734.

I've included a sample output file for reference in slcsp_output.csv, which I found useful for manually spot-checking the above edge cases.
