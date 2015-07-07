Rails.application.routes.draw do

  get  'basic/first'
  get  'basic/second'  
  post 'basic/second'   
  get  'basic/third'
  get  'basic/cancel'  
  get  'basic/new'
  post 'basic/create'
  
  get  'basic/destroy'
    
  get  'basic/indexManagement'
  get  'basic/showProgress'    
  get  'basic/editPeriod'  
  post 'basic/updatePeriod'      
  get  'basic/editGroup'  
  post 'basic/updateGroup'    
  get  'basic/sendMessage'
  post 'basic/sendMessage'  
  post 'basic/verified'
  get  'basic/destroyProgress'
  get  'basic/export_users'
  get  'basic/user_print'
  
  get  'nctu_cce/first'
  get  'nctu_cce/second'  
  post 'nctu_cce/second'   
  get  'nctu_cce/third'
  get  'nctu_cce/forth'  
  get  'nctu_cce/fifth'   
  get  'nctu_cce/cancel'
  post 'nctu_cce/feedback'   
  get  'nctu_cce/new'
  post 'nctu_cce/create'
  get  'nctu_cce/destroy'
  get  'nctu_cce/indexManagement'  
  get  'nctu_cce/showProgress'  
  get  'nctu_cce/editPeriod'  
  post 'nctu_cce/updatePeriod'     
  get  'nctu_cce/editGroup'  
  post 'nctu_cce/updateGroup'      
  get  'nctu_cce/editScore'  
  post 'nctu_cce/updateScore' 
  get  'nctu_cce/editFeedback'  
  get  'nctu_cce/askFeedback'   
  get  'nctu_cce/sendMessage'
  post 'nctu_cce/sendMessage'
  post 'nctu_cce/verified'
  get  'nctu_cce/destroyProgress'
  get  'nctu_cce/export_users'
  get  'nctu_cce/user_print'

  get  'nctu_cce_credit/first' 
  get  'nctu_cce_credit/second'    
  post 'nctu_cce_credit/second' 
  get  'nctu_cce_credit/third'
  get  'nctu_cce_credit/forth'  
  get  'nctu_cce_credit/fifth'    
  get  'nctu_cce_credit/cancel'
  post 'nctu_cce_credit/feedback'       
  get  'nctu_cce_credit/new' 
  get  'nctu_cce_credit/newCourses'  
  post 'nctu_cce_credit/newCourses'
  post 'nctu_cce_credit/create' 
  get  'nctu_cce_credit/destroy'  
  get  'nctu_cce_credit/indexManagement'  
  get  'nctu_cce_credit/showProgress'  
  get  'nctu_cce_credit/editPeriod'  
  post 'nctu_cce_credit/updatePeriod'    
  get  'nctu_cce_credit/editGroup'   
  post 'nctu_cce_credit/updateGroup'  
  get  'nctu_cce_credit/editCourses'
  post 'nctu_cce_credit/updateCourses'   
  get  'nctu_cce_credit/editScore'  
  post 'nctu_cce_credit/updateScore' 
  get  'nctu_cce_credit/editFeedback'  
  get  'nctu_cce_credit/askFeedback'    
  get  'nctu_cce_credit/sendMessage'
  post 'nctu_cce_credit/sendMessage'  
  post 'nctu_cce_credit/verified' 	
  get  'nctu_cce_credit/destroyProgress'      
  get  'nctu_cce_credit/export_users'
  get  'nctu_cce_credit/user_print'
  get  'nctu_cce_credit/attendancePrint'
 
  get  'periods/createCompletion' 
  get  'periods/showManagement'
  get  'periods/indexManagement'
  get  'periods/progress'
  get  'periods/progressStatus'  
  get  'periods/export_vaccounts'
  
  
  get  'system_modules/addAdmin'
  post 'system_modules/addAdmin'
  get  'system_modules/userIndex'
  get  'system_modules/userEdit'    
  get  'system_modules/userInfo'    
  post 'system_modules/userRole'    
  post 'system_modules/userAdd'  
  get  'system_modules/userDestroy'    
  get  'system_modules/check_account'
  post 'system_modules/check_account'
  get  'system_modules/vaccounts'
  get  'system_modules/export_summary'
  get  'system_modules/succeed'
  
  post 'users/uploadFile'
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :periods  
  resources :users
  resources :system_modules  
  root to: "periods#index"

end
