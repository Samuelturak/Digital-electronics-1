# 1. Preperation Task

## State table:

| **Input P** | **0** | **0** | **1** | **1** | **0** | **1** | **0** | **1** | **1** | **1** | **1** | **0** | **0** | **1** | **1** | **1** | 
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **State** | A | A | B | C | C | D | A | B | C | D | B | B | B | C | D | B |
| **Output R** | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 0 |

## Connection of RGB LEDs:

| **RGB LED** | **Artix-7 pin names** | **Red** | **Yellow** | **Green** |
| :-: | :-: | :-: | :-: | :-: |
| LD16 | N15, M16, R12 | 1,0,0 | 1,1,0 | 0,1,0 |
| LD17 | N16, R11, G14 | 1,0,0 | 1,1,0 | 0,1,0 |


# 2. Traffic light controller

## State Diagram

![alt text](Images/state_diagram.png)

## sequential process:

```vhdl
p_traffic_fsm : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then       -- Synchronous reset
                s_state <= STOP1 ;      -- Set initial state
                s_cnt   <= c_ZERO;      -- Clear all bits

            elsif (s_en = '1') then
                -- Every 250 ms, CASE checks the value of the s_state 
                -- variable and changes to the next state according 
                -- to the delay value.
                case s_state is

                    -- If the current state is STOP1, then wait 1 sec
                    -- and move to the next GO_WAIT state.
                    when STOP1 =>
                        -- Count up to c_DELAY_1SEC
                        if (s_cnt < c_DELAY_1SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            -- Move to the next state
                            s_state <= WEST_GO;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;

                    when WEST_GO =>
                    
                        if (s_cnt < c_DELAY_4SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            s_state <= WEST_WAIT;
                            s_cnt <= c_ZERO;
                         end if;
                    
                    when WEST_WAIT =>
                    
                       if (s_cnt < c_DELAY_2SEC) then
                           s_cnt <= s_cnt + 1;
                       else
                           s_state <= STOP2;
                           s_cnt <= c_ZERO;
                         end if;
                           
                    when STOP2 =>
                    
                       if (s_cnt < c_DELAY_1SEC) then
                           s_cnt <= s_cnt + 1;
                       else
                           s_state <= SOUTH_GO;
                           s_cnt <= c_ZERO;
                         end if;
                         
                   when SOUTH_GO =>
                    
                       if (s_cnt < c_DELAY_4SEC) then
                           s_cnt <= s_cnt + 1;
                       else
                           s_state <= SOUTH_WAIT;
                           s_cnt <= c_ZERO;
                         end if;
                         
                   when SOUTH_WAIT =>
                    
                       if (s_cnt < c_DELAY_2SEC) then
                           s_cnt <= s_cnt + 1;
                       else
                           s_state <= STOP1;
                           s_cnt <= c_ZERO;
                         end if;      
                   


                    -- It is a good programming practice to use the 
                    -- OTHERS clause, even if all CASE choices have 
                    -- been made. 
                    when others =>
                        s_state <= STOP1;

                end case;
            end if; -- Synchronous reset
        end if; -- Rising edge
    end process p_traffic_fsm;
```

## combinatorial process:

```vhdl
p_output_fsm : process(s_state)
    begin
        case s_state is
            when STOP1 =>
                south_o <= "100";   -- Red (RGB = 100)
                west_o  <= "100";   -- Red (RGB = 100)
            when WEST_GO =>
                south_o <= "100";   -- Red (RGB = 100)
                west_o  <= "010";   -- Red (RGB = 100)
            when WEST_WAIT =>
                south_o <= "100";   -- Red (RGB = 100)
                west_o  <= "110";   -- Red (RGB = 100)
            when STOP2 =>
                south_o <= "100";   -- Red (RGB = 100)
                west_o  <= "100";   -- Red (RGB = 100)
            when SOUTH_GO =>
                south_o <= "010";   -- Red (RGB = 100)
                west_o  <= "100";   -- Red (RGB = 100)
            when SOUTH_WAIT =>
                south_o <= "110";   -- Red (RGB = 100)
                west_o  <= "100";   -- Red (RGB = 100)
                


                -- WRITE YOUR CODE HERE


            when others =>
                south_o <= "100";   -- Red
                west_o  <= "100";   -- Red
        end case;
    end process p_output_fsm;
```
## Screenshot:

![alt text](Images/Graph1.PNG)

# 3. Smart controller

## State Table

| **Current State** | **Direction South** | **Direction West** | **Delay** | **00** | **01** | **10** | **11** |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| STOP1 | red | red | 1 sec | STOP1 | WEST_GO | SOUTH_GO | SOUTH_GO |
| STOP2 | red | red | 1 sec | STOP2 | WEST_GO | SOUTH_GO | WEST_GO |
| WEST_GO | red | green | 4 sec | WEST_GO | WEST_GO | WEST_WAIT | WEST_WAIT |
| WEST_WAIT | red | yellow | 2 sec | STOP1 | STOP1 | STOP1 | STOP1 |
| SOUTH_GO | green | red | 4 sec | SOUTH_GO | SOUTH_WAIT | SOUTH_GO | SOUTH_WAIT |
| SOUTH_WAIT | yellow | red | 2 sec | STOP2 | STOP2 | STOP2 | STOP2 |

## State Diagram

![alt text](Images/state_diagram2.jpg)

## sequential process:

```vhdl
p_smart_traffic_fsm : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then       -- Synchronous reset
                s_state <= STOP1 ;      -- Set initial state
                s_cnt   <= c_ZERO;      -- Clear all bits

            elsif (s_en = '1') then
                -- Every 250 ms, CASE checks the value of the s_state 
                -- variable and changes to the next state according 
                -- to the delay value.
                case s_state is

                    -- If the current state is STOP1, then wait 1 sec
                    -- and move to the next GO_WAIT state.
                    when STOP1 =>
                        -- Count up to c_DELAY_1SEC
                        if (s_cnt < c_DELAY_1SEC) then
                            s_cnt <= s_cnt + 1;
                            
                        elsif (WEST_SENSOR = '0' and SOUTH_SENSOR = '0') then
                            s_state <= STOP1;
                            s_cnt   <= c_ZERO;  
                            
                        elsif (WEST_SENSOR = '1' and SOUTH_SENSOR = '0') then
                            -- Move to the next state
                            s_state <= WEST_GO;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                            
                        else
                            s_state <= SOUTH_GO;
                            s_cnt   <= c_ZERO;
                            
                        end if;

                    when WEST_GO =>
                    
                        if (s_cnt < c_DELAY_4SEC) then
                            s_cnt <= s_cnt + 1;
                            
                        elsif (WEST_SENSOR = '0') then
                        
                            s_state <= WEST_GO;
                            s_cnt <= c_ZERO;
                            
                          else
                            s_state <= WEST_WAIT;
                            s_cnt <= c_ZERO;
                            
                          end if;
                            
                    when WEST_WAIT =>
                    
                       if (s_cnt < c_DELAY_2SEC) then
                           s_cnt <= s_cnt + 1;
                       else
                           s_state <= STOP1;
                           s_cnt <= c_ZERO;
                         end if;
                           
                    when STOP2 =>
                    
                       if (s_cnt < c_DELAY_1SEC) then
                           s_cnt <= s_cnt + 1;
                           
                       elsif (WEST_SENSOR = '1') then
                           s_state <= WEST_GO;
                           s_cnt <= c_ZERO;
                           
                       elsif (SOUTH_SENSOR = '0' and WEST_SENSOR = '1') then
                           s_state <= SOUTH_GO;
                           s_cnt <= c_ZERO;
                           
                       else
                           s_state <= STOP2;
                           s_cnt <= c_ZERO;
                           
                       end if;
                         
                   when SOUTH_GO =>
                    
                       if (s_cnt < c_DELAY_4SEC) then
                           s_cnt <= s_cnt + 1;
                           
                       elsif (WEST_SENSOR = '0') then
                           s_state <= SOUTH_GO;
                           s_cnt <= c_ZERO;
                           
                       else
                           s_state <= SOUTH_WAIT;
                           s_cnt <= c_ZERO;
                           
                       end if;
                         
                   when SOUTH_WAIT =>
                    
                       if (s_cnt < c_DELAY_2SEC) then
                           s_cnt <= s_cnt + 1;
                       else
                           s_state <= STOP2;
                           s_cnt <= c_ZERO;
                         end if;      
                   


                    -- It is a good programming practice to use the 
                    -- OTHERS clause, even if all CASE choices have 
                    -- been made. 
                    when others =>
                        s_state <= STOP1;

                end case;
            end if; -- Synchronous reset
        end if; -- Rising edge
    end process p_smart_traffic_fsm;
```

