# -*- encoding : utf-8 -*-
class Module_Say
  def init_module(bot) 
    @user_voices = ["Alex", "Bruce", "Fred", "Junior", "Agnes", "Kathy", "Princess", "Vicki", "Victoria"]
  end
  
  def privmsg(bot, from, reply_to, msg)
      converted_input = convert_input(msg)
      comment_url(from, msg)
      speak(nil, "#{from} says") if (converted_input != "")
      speak(from, "#{converted_input}") if (converted_input != "")
      pig(from, msg)
      rickroll(from, msg)
  end
  
  def botmsg(bot, target, msg)
      converted_input = convert_input(msg)
      speak(nil, "I say #{converted_input}") if (converted_input != "")
  end

private

  def comment_url(from, msg)
    if msg.include?("http://") || msg.include?("www.")
        speak(nil, "#{from} posts an url to boobs")
    end
  end

  def pig(from, msg) 
    if msg.include?("pig")
        speak(nil, "#{from} would also like to announce the following")
        speak(from, "ar ar ar niff niff niff i am a pig")
    end
  end

  def rickroll(from, msg) 
    if msg.include?("rick") || msg.include?("astley")
        say("Cellos", "#{from} I'm never gonna give you up, never gonna let you down!")
    end
  end
  
  def speak(from, text) 
    if from == nil
      say("Ralph", text)
    else
      say(get_voice(from), text)
    end
  end
  
  def say(voice, text) 
    system "say -v \"#{voice}\" \"#{text}\""
  end

  def get_voice(from) 
    sum = from.unpack("C*").inject { |s,i| s+i }
    return @user_voices[sum % @user_voices.length]
  end

  def convert_input(s) 
      s.gsub(/http:\/\/([^ ]|$)*/, "").
       gsub(/:[)DdPpEe]/, "smiley").
       gsub(":(", " sad face ").
       gsub("8-D", " dick ").
       gsub("<3", "love").
       gsub("="," equals ").
       gsub(/([ ]|^)tj([ ]|$)/i,"\\1chief executive officer\\2").
       gsub(/([ ]|^)ap([ ]|$)/i,"\\1yrro mi paysa\\2").
       gsub(/[^a-zA-Z0-9åäöÅÄÖ ,.:;!?'#€%\/()\-_<>]/u,"").
       strip
  end
end
