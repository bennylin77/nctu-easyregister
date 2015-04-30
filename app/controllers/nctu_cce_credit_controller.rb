class NctuCceCreditController < ApplicationController
  before_filter :authenticate_user!   
  before_action only: [:editItem , :updateItem, :sendMessage, :indexManagement, :destroy, :editCourses, :updateCourses] { |c| c.ItemCheckUser(params[:id])}  
  before_action only: [:cancel] { |c| c.ProgressCheckUser(params[:id])}   
  before_action only: [:editGroup, :updateGroup] { |c| c.GroupCheckUser(params[:id])}  
  before_action only: [:destroyProgress, :verified] { |c| c.ProgressCheckItemUser(params[:id])}    
  before_action only: [:updateScore] {|c| c.RegisteredSubItemCheckItemUser(params[:id])}
  
  before_action :set_item, only: [:indexManagement, :editItem, :updateItem, :editScore, :sendMessage, :destroy, :editCourses, :updateCourses, :first, :second, :third, :forth]  
  before_action :set_group, only: [:editGroup, :updateGroup]  
  before_action :set_progress, only: [:showProgress, :verified, :cancel, :destroyProgress] 
      
  def new
    @group = Group.new()
    @group.items.build()    
    @step = 2    
  end
  
  def newCourses
    @group = Group.new(group_params)      
    @step = 2     
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description},
                                    {type: 'presence', title: '報名開放時間', data: @group.items.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.items.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_start_at, second: @group.items.first.payment_end_at }}                                    
                                    ])                                  
    checkValidations(validations: validations_result, render: 'new' ) 
    @step = 3      
  end
  
  def create
    @group = Group.new(group_params)      
    @title = params[:title]
    @price = params[:price]
    @no_of_user = params[:no_of_user]    
    @step = 3    
    validations_result=validations([{type: 'presence', title: '班級名稱', data: @group.title},
                                    {type: 'presence', title: '班級簡介', data: @group.description},
                                    {type: 'presence', title: '報名開放時間', data: @group.items.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.items.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_start_at, second: @group.items.first.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'new' )       
    params[:title].each_with_index do |t, i|
      validations_result=validations([{type: 'presence', title: '課程名稱', data: t},     
                                      {type: 'presence', title: '學費', data: params[:price][i]},   
                                      {type: 'presence', title: '招生人數', data: params[:no_of_user][i]}                                                                                   
                                      ])        
      checkValidations(validations: validations_result, render: 'newCourses' )                                           
    end
    @group.items.first.user = current_user 
    @group.system_module = SystemModule.where(serial_code: GLOBAL_VAR['NCTU_CCE_credit']).first    
    @group.save      
    params[:title].each_with_index do |t, i|
      @group.items.first.sub_items.create(title: t, price: params[:price][i], no_of_user: params[:no_of_user][i])    
    end   
    redirect_to controller: :items, action: :createCompletion, id: @group.items.first.id  
  end  

  def destroy
    @item.group.destroy    
    flash[:success]="成功刪除學分班"    
    redirect_to controller: 'items', action: 'indexManagement'  
  end

  def indexManagement
    @progresses = @item.progresses.paginate(page: params[:page], per_page: 30)
  end  

  def editItem  
  end 
  
  def updateItem
    @item.assign_attributes(item_params)
    validations_result=validations([{type: 'presence', title: '報名開放時間', data: @item.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @item.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @item.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @item.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @item.start_at, second: @item.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @item.payment_start_at, second: @item.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'editItem' )   
    @item.save  
    flash[:success]="成功更新基本資料"
    redirect_to controller: :nctu_cce_credit, action: :indexManagement, id: @item.id     
  end  
  
  def editGroup  
  end 
  
  def updateGroup
    @group.assign_attributes(group_params)
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description}])                                   
    checkValidations(validations: validations_result, render: 'editGroup' )   
    @group.save  
    flash[:success]="成功更新名稱簡介"
    redirect_to controller: :nctu_cce_credit, action: :indexManagement, id: @group.items.first.id     
  end    
  
  def editCourses     
  end
  
  def updateCourses  
    @item.assign_attributes(item_params)        
    @item.sub_items.each do |ii|
      validations_result=validations([{type: 'presence', title: '課程名稱', data: ii.title},     
                                      {type: 'presence', title: '學費', data: ii.price},   
                                      {type: 'presence', title: '招生人數', data: ii.no_of_user}                                                                                   
                                      ])        
      checkValidations(validations: validations_result, render: 'editCourses' )                                           
    end    
    @item.save  
    flash[:success]="成功更新課程"
    redirect_to controller: :nctu_cce_credit, action: :indexManagement, id: @item.id        
  end

  def editScore
  end
    
  def updateScore
    rsi = RegisteredSubItem.find(params[:id])
    case params[:type]
    when 'score'
      rsi.score = params[:val]
      rsi.save!
      render json: {success: true, message: '成功更改分數'}                 
    when 'attendance'  
      rsi.attendance = params[:val]
      rsi.save!
      render json: {success: true, message: '成功更改出席率'}                                           
    end    
  end
  
    
  def sendMessage 
    if request.post?       
      params[:recipients].each do |r|
        System.sendMessage(user: User.find(r), subject: params[:subject], content: params[:content], attachment: params[:attachment], sender: current_user).deliver
      end 
      flash[:success]="成功寄出信件"                
      redirect_to controller: :nctu_cce_credit, action: :indexManagement, id: @item.id     
    end
  end  
  
  def verified
    if params[:verify] == 'false'
      @progress.verified=false
      @progress.stage= 1
      @progress.reason = params[:reason]
      @progress.registered_sub_items.destroy_all
      if @progress.vaccount
        @progress.vaccount.active = false 
        @progress.vaccount.save!
      end
      @progress.save!
      flash[:alert]="審核不通過/取消資格 "+@progress.user.name+" 的報名"
      System.sendUnverified(user: @progress.user, progress: @progress).deliver         
    else
      @progress.verified=true 
      @progress.payment = params[:sub_item_payments].map(&:to_i).reduce(0, :+)
      params[:sub_item_ids].each_with_index do |id, idx|
      	item = @progress.registered_sub_items.find(id)
      	item.payment = params[:sub_item_payments][idx].to_f
      	item.save!
      end
      if @progress.vaccount #可能之前被退回時就創過
      	@progress.vaccount.active = true
      	@progress.vaccount.save!
      elsif @progress.payment > 0 #若免錢就不給帳號
      	 @progress.create_vaccount
      end	 
      @progress.stage= (@progress.payment > 0) ? 3 : 4 #免錢直接過 stage==4  
      @progress.save!    
      flash[:success]="已審核通過 "+@progress.user.name+" 的報名"
      System.sendVerified(user: @progress.user, progress: @progress).deliver         
    end
    redirect_to controller: 'nctu_cce_credit', action: 'showProgress', id: @progress.id
  end

  def destroyProgress
    item = @progress.item
    @progress.destroy    
    flash[:success]="成功刪除報名"    
    redirect_to controller: 'nctu_cce_credit', action: 'indexManagement', id: item.id       
  end
  
  def showProgress
  	@progress = Progress.find(params[:id])
  end
  
 

# ------------ booking --------------#
  def cancel
    @progress.destroy
    flash[:success]="成功退出報名"    
    redirect_to controller: 'items', action: 'progress'   
  end

  def first
    @user=current_user 
    progress = @item.progresses.where(user_id: current_user.id).first
    if progress.blank?
      @progress=Progress.new
      @progress.stage=1
      @progress.user = current_user           
      @progress.item = @item                  
      @progress.save           
    else
      @progress = progress        
    end    
    @step = 1      
  end  

  def second
    if request.post?
      user = current_user  
      user.assign_attributes(user_params) 
      @step = 1      
      @progress = @item.progresses.where(user_id: current_user.id).first                   
      validations_result=validations([{type: 'presence', title: '姓名', data: user_params[:name]}, 
                                      {type: 'presence', title: '英文姓名', data: user_params[:name_en]},      
                                      {type: 'presence', title: '出生年月日', data: user_params[:birthday]},
                                      {type: 'presence', title: '性別', data: user_params[:gender]},
                                      {type: 'presence', title: '身分證字號', data: user_params[:id_no_TW]},                                      
                                      {type: 'presence', title: '聯絡電話(行動)',data: user_params[:mobile_phone_no]},
                                      {type: 'presence', title: '郵遞區號', data: user_params[:postal]},
                                      {type: 'presence', title: '聯絡地址-縣市', data: user_params[:county]},                                      
                                      {type: 'presence', title: '聯絡地址-鄉鎮市區', data: user_params[:district]},        
                                      {type: 'presence', title: '聯絡地址-詳細', data: user_params[:address]},
                                      {type: 'presence', title: '最高(畢/肄/就讀)學校', data: user_params[:hightest_education_school]},
                                      {type: 'presence', title: '最高(科/系/所)', data: user_params[:hightest_education_department]},                                      
                                      {type: 'id_no_TW', title: '身分證字號', data: user_params[:id_no_TW]}])
      checkValidations(validations: validations_result, render: 'first' )               
      user.save    
      validations_result=validations([{type: 'presence', title: '選擇課程', data: params[:courses]}])      
      checkValidations(validations: validations_result, render: 'first' )      
      @progress.stage=2
      @progress.reason = ''        
      @progress.save   
      params[:courses].each do |c|
        registered_sub_item = RegisteredSubItem.new  
        @progress.registered_sub_items << registered_sub_item
        @item.sub_items.where(id: c).first.registered_sub_items << registered_sub_item  
        registered_sub_item.save 
      end
      @item.save                  
      System.sendVerifyNotification(user: @progress.item.user, progress: @progress).deliver                              
    else
      @progress = @item.progresses.where(user_id: current_user.id).first               
    end 
    @step = 2         
  end
  
  
  def third
    @step = 3     
    @progress = @item.progresses.where(user_id: current_user.id).first  
  end
  
  def forth
    @step = 4       
    @progress = @item.progresses.where(user_id: current_user.id).first    
  end
  
  private

  def set_item
    @item = Item.find(params[:id])
  end 
  
  def set_group
    @group = Group.find(params[:id])
  end   
  
  def set_progress
    @progress = Progress.find(params[:id])     
  end
  
  def item_params
    params.require(:item).permit( :start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, sub_items_attributes: [:title, :no_of_user, :price, :id])      
  end

  def user_params
    params.require(:user).permit(:name, :birthday, :gender, :id_no_TW, :mobile_phone_no, :phone_no, :address, 
                                 :postal, :county, :district, :name_en, :hightest_education_school, :hightest_education_department,
                                 :work_name, :work_title, :work_phone_no, :work_fax_no, :work_county, :work_district, :work_postal, :work_address,
                                 :work_contact_name, :work_contact_phone_no, :work_contact_email)      
  end
  
  def group_params
    params.require(:group).permit(:title, :description, items_attributes: [:verification_code, :no_of_user, :price,
                                  :start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, :term, :waiting_available])
  end      
end
