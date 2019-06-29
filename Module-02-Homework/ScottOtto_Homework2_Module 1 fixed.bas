Attribute VB_Name = "Module1"
Sub StockMarketMed()

    'Loop through all the sheets
    For Each ws In Worksheets
    
        'Label the Headers
        ws.Cells(1, 9).Value = "Symbol"
        ws.Cells(1, 10).Value = "Yearly Change"
        ws.Cells(1, 11).Value = "Percent Change"
        ws.Cells(1, 12).Value = "Total Volume"
        ws.Cells(2, 15).Value = "Greatest % Increase"
        ws.Cells(3, 15).Value = "Greatest % Decrease"
        ws.Cells(4, 15).Value = "Maximum Volume"
        ws.Cells(1, 16).Value = "Symbol"
        ws.Cells(1, 17).Value = "Value"

        'Set Variable for holding the ticker symbol
        Dim TickerSymbol As String
                
        'Set Variable for holding the total volume
        Dim TotalVolume As Double
        TotalVolume = 0
        
        'Set Variable for January 1 close - although called JanClose, it takes the first closing price for a ticker symbol, regardless of date
        Dim JanClose As Double
        JanClose = 0
        
        'Set Variable for Yearly Change (December 30 Close - Jan 1 Close)
        Dim YearlyChange As Double
        YearlyChange = 0
        
        'Set Variable for PercentChange of December 30 Close and Jan 1 Close
        Dim PercentChange As Double
                
        'Determine Last Row
        LastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
                
        'Keep track of the location for each Ticker Symbol in the summary table
        Dim Summary_Table_Row As Integer
        Summary_Table_Row = 2
        
            JanClose = ws.Cells(2, 6)
        
                'loop through all ticker symbols
                For i = 2 To LastRow
                
                        'Check if we are still in the same Ticker Symbol, if it is not...
                        If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then
                        
                                    'Set the Ticker Symbol
                                     TickerSymbol = ws.Cells(i, 1).Value
                                  
                                      'Set the yearly change
                                      YearlyChange = ws.Cells(i, 6).Value - JanClose
                                  
                                      'Set the yearly Percent Change
                                      If JanClose = 0 Then
                                      PercentChange = 0
                                      Else
                                            PercentChange = (YearlyChange / JanClose)
                                      End If
                            
                                      'Add to the TotalVolume
                                      TotalVolume = TotalVolume + ws.Cells(i, 7).Value
                            
                                     'Print the Ticker Symbol in the summary table
                                      ws.Range("I" & Summary_Table_Row).Value = TickerSymbol
                                   
                                     'Print the Yearly Change in the summary table
                                      ws.Range("J" & Summary_Table_Row).Value = YearlyChange
                                      
                                        'Conditional formatting highlighting positive change(green) and negative change(red)
                                        If ws.Range("J" & Summary_Table_Row).Value > 0 Then
                                                     ws.Range("J" & Summary_Table_Row).Interior.ColorIndex = 4
                                        Else
                                                     ws.Range("J" & Summary_Table_Row).Interior.ColorIndex = 3
                                        End If
                                   
                                     'Print the Percent Change in the summary table
                                      ws.Range("K" & Summary_Table_Row).NumberFormat = "0.00%"
                                      ws.Range("K" & Summary_Table_Row).Value = PercentChange
                                   
                                     'Print the TotalVolume to the summary table
                                      ws.Range("L" & Summary_Table_Row).Value = TotalVolume
                            
                                     'Add one to the summary table row
                                     Summary_Table_Row = Summary_Table_Row + 1
                            
                                     'Reset the PercentChange
                                     PercentChange = 0
                                                        
                                     'Reset the YearlyChange
                                     YearlyChange = 0
                                  
                                     'Reset the TotalVolume
                                     TotalVolume = 0
                                  
                                     'Reset JanClose
                                     JanClose = ws.Cells(i + 1, 6).Value
                    
                        'If the cell immediately following a row is the same TickerSymbol...
                        Else
                                If JanClose = 0 Then
                                JanClose = ws.Cells(i, 6).Value
                                End If
                                
                                'Add to the TotalVolume
                                TotalVolume = TotalVolume + ws.Cells(i, 7).Value
                                
                        
                        End If
                        
                Next i
                
                
                'Locate Stocks on sheet with:
                    'greatest percent increase
                    'greatest percent decrease
                    'greatest total volume
            
                
                'Set Variables for Last Row, Largest % Increase, Largest % Decrease and Largest total volume
                Dim LastRow2 As Integer
                Dim IncreaseMax As Double
                Dim DecreaseMax As Double
                Dim VolumeMax As Double
                
                'Set startingv alues for Last Row, Largest % Increase, Largest % Decrease and Largest total volume
                IncreaseMax = 0
                DecreaseMax = 0
                VolumeMax = 0
                
                LastRow2 = ws.Cells(Rows.Count, 9).End(xlUp).Row
                
                For j = 2 To LastRow2
                
                
                            'Find Largest % Increase and place in cell
                            If ws.Cells(j, 11).Value > IncreaseMax Then
                                    IncreaseMax = ws.Cells(j, 11).Value
                                    ws.Cells(2, 16) = ws.Cells(j, 9).Value
                                    ws.Cells(2, 17) = IncreaseMax
                                    ws.Cells(2, 17).NumberFormat = "0.00%"
                                    
                                'Find Largest % Decrease and place in cell
                                ElseIf ws.Cells(j, 11).Value < DecreaseMax Then
                                        DecreaseMax = ws.Cells(j, 11).Value
                                        ws.Cells(3, 16) = ws.Cells(j, 9).Value
                                        ws.Cells(3, 17) = DecreaseMax
                                        ws.Cells(3, 17).NumberFormat = "0.00%"
                            End If
                        
                            'Get Largest total volume and place in cell
                            If ws.Cells(j, 12).Value > VolumeMax Then
                                    VolumeMax = ws.Cells(j, 12).Value
                                    ws.Cells(4, 16) = ws.Cells(j, 9).Value
                                    ws.Cells(4, 17) = VolumeMax
                                    
                            End If
        
                Next j
                        
        Next ws
                        
End Sub

