module BasicHelper  
  def basicStageText(stage)
    case stage    
      when 1
        "填表中"     
      when 2
        "待審核"
      when 3
        "完成報名"    
      when -1
        "已取消報名"
    end
  end 
end