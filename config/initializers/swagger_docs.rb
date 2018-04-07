Swagger::Docs::Config.register_apis({
  "1.0" => {
    api_extension_type: :json,
    api_file_path: "public/api/v1/",
    base_path: "https://localhost:3000/api/v1/",
    clean_directory: false,
    base_api_controller: ApplicationController  
  }
})