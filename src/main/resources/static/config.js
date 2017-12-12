env_base_config = {
    server_base_url:'http://127.0.0.1:8012/',
}
env_config = {
    server_base_url:env_base_config.server_base_url,
    server_preview_url:env_base_config.server_base_url + 'onlinePreview?url=',
    server_delete_url:env_base_config.server_base_url + 'deleteFile?fileName=',
}