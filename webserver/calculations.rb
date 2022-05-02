def get_cost_of_equity(dividends_per_share_next_year, current_share_price, growth_rate_dividends)
    cost = (dividends_per_share_next_year/current_share_price) + growth_rate_dividends
    return cost
end 

def get_wacc(market_value_equity, market_value_debt, cost_debt, corporate_tax_rate, cost_of_equity)
    wacc = (market_value_equity/(market_value_debt + market_value_equity)) * cost_of_equity + (market_value_debt/(market_value_debt + market_value_equity)) * cost_debt * (1 - corporate_tax_rate)
    return wacc
end 

def get_dcf(profit, growth_rate, additional_years, wacc)
    i = 0 
    sum = 0
    while i <= additional_years 
        sum += profit * (growth_rate ** (i + 1) / ((1 + wacc) ** (i + 1)))
        i += 1
    end 
    sum += profit * (growth_rate ** ((additional_years + 1)/((1 + wacc) ** (additional_years + 1)))) * 11.1
    return sum
end 

def get_net_cash(rentbearing_assets, rentbearing_debt)
    nc = rentbearing_assets - rentbearing_debt 
    return nc 
end

def get_value(share_quantity, net_cash, dcf)
    return ((net_cash + dcf)/share_quantity).round(2)
end 

def percentage(value, price)
    sum = (value/price)
    if sum > 1 
        sum -= 1
        sum = (sum * 100).round(1)
        return "Aktien har #{sum}% potentiell uppgång i värde"
    elsif sum < 1 
        sum = 1 - sum 
        sum = (sum * 100).round(1)
        return "Aktien har #{sum}% potentiell nedgång i värde"
    else 
        return "Värdet är samma som priset!"
    end 
end 
