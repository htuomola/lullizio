# -*- encoding : utf-8 -*-
Kernel.load("fetch_uri.rb")

class Module_Postlinks
  def init_module(bot) 
	@accessToken = bot.module_config["postlinks_accesstoken"]
	@endpoint = bot.module_config["postlinks_url"]
  
  end
  
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /^http:\/\//
		title = post_link(word, nil, from, reply_to, @endpoint, @accessToken)
		bot.send_privmsg(reply_to, title)
      end
    }
  end

  def botmsg(bot,target,msg) end


end

