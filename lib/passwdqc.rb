require 'ffi'

class Passwdqc
  extend FFI::Library
  ffi_lib :libpasswdqc, FFI::Library::LIBC

  class ParamsQc_t < FFI::Struct
    layout  :min,               [:int, 5],
            :max,               :int,
            :passphrase_words,  :int,
            :match_length,      :int,
            :similar_deny,      :int,
            :random_bits,       :int
  end

  class ParamsPam_t < FFI::Struct
    layout  :flags, :int,
            :retry, :int
  end

  class Params_t < FFI::Struct
    layout  :qc,  ParamsQc_t,
            :pam, ParamsPam_t
  end

  attach_function :passwdqc_check,  [ParamsQc_t.ptr, :string, :string, :buffer_in], :string
  #attach_function :passwdqc_random, [ParamsQc_t.ptr],                               :pointer

  attach_function :passwdqc_params_parse, [Params_t.ptr, :buffer_out, :int, :buffer_in],  :int
  attach_function :passwdqc_params_load,  [Params_t.ptr, :buffer_out, :string],           :int
  attach_function :passwdqc_params_reset, [Params_t.ptr],                                 :void

  attach_function :free,  [:pointer], :void

  F_ENFORCE_MASK          = 0x00000003
  F_ENFORCE_USERS         = 0x00000001
  F_ENFORCE_ROOT          = 0x00000002
  F_ENFORCE_EVERYONE      = F_ENFORCE_MASK
  F_NON_UNIX              = 0x00000004
  F_ASK_OLDAUTHTOK_MASK   = 0x00000030
  F_ASK_OLDAUTHTOK_PRELIM = 0x00000010
  F_ASK_OLDAUTHTOK_UPDATE = 0x00000020
  F_CHECK_OLDAUTHTOK      = 0x00000040
  F_USE_FIRST_PASS        = 0x00000100
  F_USE_AUTHTOK           = 0x00000200

  def initialize(pathname = nil)
    @params = Params_t.new
    params_reset
    params_load(pathname) if pathname
  end

  def check(newpass, oldpass = nil)
    passwdqc_check(@params[:qc], newpass, oldpass, nil)
  end

  # def random
  #   if (pw_ptr = passwdqc_random(@params[:qc])).null?
  #     raise NoMemoryError
  #   end

  #   passwd = pw_ptr.get_string(0)
  #   free(pw_ptr)
  #   passwd
  # end

  def params_load(pathname)
    ptr = FFI::MemoryPointer.new(:pointer, 1, true)
    if passwdqc_params_load(@params, ptr, pathname) == -1
      reason_ptr = ptr.read_pointer
      reason = reason_ptr.null? ? nil : reason_ptr.get_string(0)
      free(reason_ptr)
      raise ArgumentError, reason, caller
    end
    true
  end

  def params_reset
    passwdqc_params_reset(@params)
  end
end
