#
# Convert PO file to 
#


#
# contents is Array includes each lines
#
class PoTools
  def initialize
  end

  def porip(contents)
    # 最初にplaceが出現したらheader = falseにする
    is_header = true
    prev = :header
    words = []
    header = ""
    $line_num = 0
    
    word = {}
    contents.each do |line|
      $line_num += 1
      if line =~ /^\#:/
        raise 'ParseError' unless (prev == :msgstr or prev == :msgstr_n or prev == :header or prev == :blank or prev == :place)
    
        if word[:place]
          word[:place] << line
        else
          word[:place] = line
        end
    
        prev = :place
        is_header = false
      elsif line =~ /^\#/
        prev = :comment
      elsif line =~ /^\s+$/  # 空行の場合
        if prev == :msgstr_n or prev == :msgstr
          words << word
          word = {}
        end
        prev = :blank
      elsif line =~ /^msgid_plural.+$/
        raise 'ParseError' unless prev == :msgid
        word[:msgid_plural] = get_double_quated_string(line)
        prev = :msgid_plural
      elsif line =~ /^msgid.+$/
        # headerのうちは単に無視する
        unless is_header
          raise 'ParseError' unless prev == :place
          word[:msgid] = get_double_quated_string(line)
          prev = :msgid
        end
      elsif line =~ /^\".+\"$/
        if prev == :msgid
          word[:msgid] << get_double_quated_string(line)
          prev = :msgid
        elsif prev == :msgid_plural
          word[:msgid_plural] << get_double_quated_string(line)
          prev = :msgid_plural
        elsif prev == :msgstr
          word[:msgstr] << get_double_quated_string(line)
          prev = :msgstr
        end
      elsif line =~ /^msgstr\[[0-9]\].+$/
        raise 'ParseError' unless (prev == :msgid_plural or prev == :msgstr_n)
        if $& =~ /[0-9]+/
          n = $&.to_i
          unless word[:msgstrs]
            word[:msgstrs] = []
          end
          word[:msg_type] = 'msgstrs'
          word[:msgstrs][n] = get_double_quated_string(line)
        else
          raise 'ParseError'
        end
        prev = :msgstr_n
      elsif line =~ /^msgstr.+$/
        # headerのうちは単に無視する
        unless is_header
          raise 'ParseError' unless prev == :msgid
          word[:msg_type] = 'msgstr'
          word[:msgstr] = get_double_quated_string(line)
          prev = :msgstr
        end
      else
      end
    
      if is_header == true
        header << line 
      end
    
    end
  
    return header, words
  
  end
  
  def pobuild(header, messages)
    po_str = header
    messages.each do |msg|
      po_str << msg[:place]
      po_str << "msgid \"#{msg[:msgid]}\"\n"
      if msg[:msg_type] == 'msgstr'
        po_str << "msgstr \"#{msg[:msgstr]}\"\n"
      elsif msg[:msg_type] == 'msgstrs'
        po_str << "msgid_plural \"#{msg[:msgid_plural]}\"\n"
        msg[:msgstrs].each_index do |i|
          po_str << "msgstr[#{i}] \"#{msg[:msgstrs][i]}\"\n"
        end
      end
      po_str << "\n"
    end
    return po_str
  end
  
  def get_double_quated_string(line)
    return line.scan(/\".*\"$/)[0][1..-2]
  end

end

if __FILE__ == $0
  contents = []
  File.open('noosfero.po', 'r') do |f|
    contents = f.readlines
  end

  potool = PoTools.new
  header, words = potool.porip(contents)

  print(potool.pobuild(header, words))
end

