require 'csv'

def perflogana(csvfile)

  #initial an array
   a = Array.new(1){ Array.new(4) }

   a[0][0] = '';
   a[0][1] = 0; # total cost time
   a[0][2] = 0; # invocations
   a[0][3] = 0; # Avg time
   a[0][4] = 0; # Max value
   a[0][5] = 0; # Over 3 seconds Count
   a[0][6] = 0.0; # % of over 3 seconds
   i = 0;
   t = 0;
   n = 0;

   flag = 'unfound'

  # Read each line from CSV file
  CSV.foreach(csvfile) do |row|

    if (!row[1].nil?)
      #Trim Oid for the URL using regex
      if row[1].gsub!(/\/([\d\D][^\/]+?-)+\S*/, "")
         row[1] << "\/"
      end

      b = 0;
      # modify total response time and invocations if current line being found
      while b <= i
        if !a[b][0].eql?(row[1])
           b= b+1;
           next;
        else
           # modify total response time and invocations
           a[b][1] = a[b][1] + row[2].to_s.to_i;
           a[b][2] = a[b][2] + 1;
           a[b][4] = row[2].to_s.to_i if row[2].to_s.to_i > a[b][4];
           a[b][5] = a[b][5] + 1 if row[2].to_s.to_i > 3000000;
           flag = 'find'
           break;
        end
      end

      #append a new line if new transaction being found
      if flag.eql?('unfound')

          if row[2].to_s.to_i < 3000000
            a << [row[1],row[2].to_s.to_i,1,0,row[2].to_s.to_i,0];
          else
            a << [row[1],row[2].to_s.to_i,1,0,row[2].to_s.to_i,1];
          end

          i = i+1;
      end

      flag = 'unfound'
    end

  end

  a.shift

  j = a.size
  #calculate average response time for each transaction
  while t < j
    a[t][3] = a[t][1]/a[t][2]
    a[t][6] = (a[t][5].to_f/a[t][2].to_f * 100.0).round
    t = t+1;
  end

  #print to console
  while n < j
    print a[n][0],",",a[n][1],",",a[n][2],",",a[n][3],",",a[n][4],",",a[n][5],",",a[n][6]
    puts
    n = n + 1
  end

end

perflogana("D:\\GWT_automation\\release\\0630\\CBSWeb01LOG\\access_0630_18\.csv");