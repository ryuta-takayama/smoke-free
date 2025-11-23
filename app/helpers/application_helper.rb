module ApplicationHelper
	# Returns a hash of milestones => [icon_filename, message]
	def streak_badges
		{
			3    => ['walking-time-svgrepo-com.svg',         '3日達成！'],
			7   => ['run-person-fast-rush-svgrepo-com.svg', '1週間達成！　その調子で！'],
			30   => ['flag-svgrepo-com.svg',                 '1か月達成！　いいね！'],
			90   => ['flag-svgrepo-com.svg',                 '3か月達成！　だんだんと軽くなったんじゃない！？'],
			180  => ['star-half-stroke-filled-svgrepo-com.svg','半年達成！　ほんとすごい！'],
			365  => ['trophy-svgrepo-com.svg',               '1年達成！　おめでとう！'],
			1095 => ['brand-firebird-svgrepo-com.svg',       '3年達成！　神だ！']
		}
	end

	# Returns { days:, icon:, text: } for the latest reached milestone, or nil if none.
	def latest_streak_badge(current_days)
		cd = current_days.to_i
		reached = streak_badges.select { |d, _| cd >= d }
		return nil if reached.empty?
		days, (icon, text) = reached.max_by { |d, _| d }
		{ days: days, icon: icon, text: text }
	end

	# Health improvement milestones (in minutes from start) => message.
	# Use minutes for easy comparison: 20min, 12h, 48h, etc.
	def health_improvement_milestones
		{
			0       => '禁煙開始 — 新しいスタートです',            # 0 minutes
			20      => '20分後 — 心拍数・血圧が低下',             # 20 minutes
			12*60   => '12時間後 — 血中一酸化炭素が正常化',       # 12 hours
			2*24*60 => '2日後 — 味覚・嗅覚が改善',               # 2 days
			14*24*60=> '2週間後 — 血液循環が改善',               # 2 weeks
			30*24*60=> '1ヶ月後 — 肺機能向上'                    # 1 month (approx)
		}
	end

	# Returns array of reached health messages given minutes elapsed.
	def reached_health_messages(elapsed_minutes)
		ms = elapsed_minutes.to_i
		health_improvement_milestones.select { |min, _| ms >= min }.values
	end

  # Options for User.reason_to_quit enum with Japanese labels
  def reason_to_quit_options
    labels = {
      health: "健康のため",
      money:  "節約のため",
      family: "家族のため",
      work:   "仕事・勉強",
      other:  "その他"
    }
    User.reason_to_quits.keys.map { |key| [labels[key.to_sym] || key.humanize, key] }
  end
end
