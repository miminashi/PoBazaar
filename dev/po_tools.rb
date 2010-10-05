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
    #
    is_header = true
    prev = :header
    words = []
    header = ""
    $line_num = 0
    
    word = {}
    contents.each do |line|
      $line_num += 1
      #p prev
      #p line
      if line =~ /^\#:/
        raise 'ParseError' unless (prev == :msgstr or prev == :msgstr_n or prev == :header or prev == :blank or prev == :place)
    
        #if word[:place]
        #  place = word[:place]
        #else
        #  place = ''
        #end
        #place << line
        #word[:place] = place
        if word[:place]
          word[:place] << line
        else
          #word = {}  # 一時保存用hashを初期化
          word[:place] = line
        end
    
        prev = :place
        is_header = false
        #puts "#{header.to_s}, place: #{line}"
      elsif line =~ /^\#/
        prev = :comment
    
        #puts "#{header.to_s}, comment: #{line}"
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
        #p line
        # headerのうちは単に無視する
        unless is_header
          #begin   # test code
            raise 'ParseError' unless prev == :place
          #rescue  # test code
          #  p line  # test code
          #  p words.size  # test code
          #  exit(1)  # test code
          #end  # test code
          #p line.split('"')[1]
          #word[:msgid] = line.split('"')[1]
          #word[:msgid] = line.scan(/\".+\"$/)[0][1..-2]
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
        #elsif prev == :msgstr_n
        end
      elsif line =~ /^msgstr\[[0-9]\].+$/
        #begin
          raise 'ParseError' unless (prev == :msgid_plural or prev == :msgstr_n)
        #rescue
        #  p line
        #  p line_num
        #  exit(1)
        #end
        if $& =~ /[0-9]+/
          n = $&.to_i
          #p n
          unless word[:msgstrs]
            #p line
            word[:msgstrs] = []
          end
          #word[:msgstrs][n] = line.split('"')[1]
          word[:msg_type] = 'msgstrs'
          word[:msgstrs][n] = get_double_quated_string(line)
          #p word[:msgstrs]
        else
          raise 'ParseError'
        end
        prev = :msgstr_n
      elsif line =~ /^msgstr.+$/
        # headerのうちは単に無視する
        unless is_header
          #begin
            raise 'ParseError' unless prev == :msgid
          #rescue
          #  p line
          #  p prev
          #  exit(1)
          #end
          #p line.split('"')[1]
          #word[:msgstr] = line.split('"')[1]
          word[:msg_type] = 'msgstr'
          word[:msgstr] = get_double_quated_string(line)
          #words << word  # 1セクションを全セクションに追加して
          #word = {}      # 一時保持用ハッシュを初期化
          prev = :msgstr
          #puts "#{header.to_s}, comment: #{line}"
        end
      else
        #puts "#{header.to_s}, else: #{line}"
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
    begin
      return line.scan(/\".*\"$/)[0][1..-2]
    rescue
      p $line_num
      p line
      exit(1)
    end
  end

end

if __FILE__ == $0
  #require 'pp'

  contents = []
  File.open('noosfero.po', 'r') do |f|
    contents = f.readlines
  end

  potool = PoTools.new
  header, words = potool.porip(contents)

  #pp words
  #print header
  #puts "#{words.size} words analyzed"

  print(potool.pobuild(header, words))
end

