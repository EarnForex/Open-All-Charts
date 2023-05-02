#property link          "https://www.earnforex.com/metatrader-scripts/open-all-charts/"
#property version       "1.01"
#property strict
#property copyright     "EarnForex.com - 2020-2023"
#property script_show_inputs
#property description   "This script will open all the chats of currency pairs in a specified timeframe."
#property description   "Supports a list of currencies separated by comma."
#property description   ""
#property description   "Find More on www.EarnForex.com"
#property icon          "\\Files\\EF-Icon-64x64px.ico"

input ENUM_TIMEFRAMES Timeframe = PERIOD_CURRENT;
input string Currencies = "EUR, USD, GBP, JPY, CAD, CHF, AUD, NZD";

void OnStart()
{
    string currencies[];
    int total_currencies = StringSplit(Currencies, StringGetCharacter(",", 0), currencies);
    
    bool all_pairs = false;
    if (Currencies == "") // Empty list means all pairs.
    {
        all_pairs = true;
        total_currencies = 1; // To currencies cycle launch the cycle.
        Print("Opening ALL charts...");
    }
    if (!all_pairs) 
    {
        if (total_currencies <= 0)
        {
            Print("No currencies to work on. List currencies using comma as a separator.");
            return;
        }
        for (int j = 0; j < total_currencies; j++)
        {
            currencies[j] = StringTrimLeft(StringTrimRight(currencies[j])); // Trim the whitespace.
            StringToUpper(currencies[j]); // Convert to uppercase.
        }
    }
    
    int total_symbols = SymbolsTotal(false); // All available symbols, not only those in the Market Watch.
    for (int i = 0; i < total_symbols; i++) // Cycle through all available currency pairs.
    {
        string symbol = SymbolName(i, false); // All available symbols, not only those in the Market Watch.
        string symbol_uppercase = symbol;
        StringToUpper(symbol_uppercase);
        for (int j = 0; j < total_currencies; j++) // Cycle through given currencies.
        {
            if ((all_pairs) || (StringFind(symbol_uppercase, currencies[j]) != -1)) // Either all symbols are required or found a pair containing the currency. 
            {
                SymbolSelect(symbol, true);
                if (ChartOpen(symbol, Timeframe) == 0)
                {
                    Print("Error opening " + symbol + " chart: " + IntegerToString(GetLastError()));
                }
                break; // Go to the next currency pair. No need to check the same pair with other currencies if it has already been opened.
            }
        }
    }
    if (all_pairs) Print("Finished opening ALL charts.");
}
//+------------------------------------------------------------------+