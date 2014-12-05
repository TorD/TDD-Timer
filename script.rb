#==============================================================================
# ** TDD::Timer
#------------------------------------------------------------------------------
# Version:  1.0.0
# Date:     06/12/2014
# Author:   Galenmereth / Tor Damian Design
#
# Description
# ===========
# This script is for use within other scripts. It lets you call a method for
# an object after X defined frames. Super lightweight, and hooks into
# Scene_Base frame update with a simple alias
#
# How to use
# ==========
# TDD::Timer.call_after_frames(
#   :frames   => Number,  - Number of frames to wait before calling :method
#   :observer => Object,  - Object for which method should be called
#   :method   => :symbol, - Method to call on :observer Object
#   :params   => Object,  - OPTIONAL: Any object you wish to pass to the :method
# )
#
# Example
# =======
# TDD::Timer.call_after_frames(
#   :frames   => 60,
#   :observer => self,
#   :method   => :play_ding_dong_sfx,
#   :params   => {ding: dong}
# )
#
# You can pass the above params in any order you wish, and :params can be
# omitted.
#
# Credit:
# =======
# - Galenmereth / Tor Damian Design
#
# License:
# ========
# Free for non-commercial and commercial use. Credit greatly appreciated but
# not required. Share script freely with everyone, but please retain this
# description area unless you change the script completely. Thank you.
#==============================================================================
module TDD
class Timer
  @@timers = []
  class << self
    def call_after_frames(args={})
      timer_object = {
        :observer => nil,
        :method => nil,
        :params => nil,
        :frames => 0
      }.merge(args)

      # Raise error unless required params
      raise "#{self}: Requires observer and method" unless timer_object[:observer] && timer_object[:method]

      # Push into timer queue
      @@timers.push(timer_object)
    end

    def update
      @@timers.each do |timer_object|
        if timer_object[:frames] > 0
          # Reduce frames left if any
          timer_object[:frames] -= 1
        else
          # Call method with params if no more frames to count down
          if timer_object[:params]
            timer_object[:observer].send(timer_object[:method], timer_object[:params])
          else
            timer_object[:observer].send(timer_object[:method])
          end

          # Remove from timers
          @@timers.delete(timer_object)
        end
      end
    end
  end
end
end
class Scene_Base
  #--------------------------------------------------------------------------
  # * ALIAS Frame Update
  #--------------------------------------------------------------------------
  alias_method :tdd_timer_scene_update_basic_extension, :update_basic
  def update_basic
    TDD::Timer.update
    tdd_timer_scene_update_basic_extension
  end
end