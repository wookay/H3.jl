module test_h3_api_errors

using Test
using H3.API # H3ErrorCode, describeH3Error
using H3.Lib: Lib, H3Error, E_SUCCESS, E_FAILED

@test describeH3Error(H3Error(E_SUCCESS)) ==
      describeH3Error(H3ErrorCode(E_SUCCESS)) ==
      describeH3Error(E_SUCCESS) ==
      "Success"
@test describeH3Error(E_FAILED) == "The operation failed but a more specific error is not available"

# H3ErrorCode
@test H3ErrorCode(E_SUCCESS) == H3ErrorCode(E_SUCCESS)
@test H3ErrorCode(E_SUCCESS) != H3ErrorCode(E_FAILED)
@test H3ErrorCode(E_SUCCESS).value isa H3Error
@test H3ErrorCode(E_SUCCESS).value == E_SUCCESS

# Lib.H3ErrorCodes
@test E_SUCCESS == E_SUCCESS
@test E_SUCCESS != E_FAILED
@test H3Error(E_SUCCESS) isa H3Error
@test Lib.H3ErrorCodes(H3Error(E_SUCCESS)) == E_SUCCESS
@test E_SUCCESS in instances(Lib.H3ErrorCodes)
@test E_SUCCESS isa Lib.H3ErrorCodes
@test E_FAILED isa Lib.H3ErrorCodes

function sprint_error_code(code::H3ErrorCode)::String
    sprint(io -> show(io, MIME"text/plain"(), code))
end

@test sprint_error_code(H3ErrorCode(E_SUCCESS)) == "H3ErrorCode(E_SUCCESS): Success"
@test sprint_error_code(H3ErrorCode(E_FAILED))  == "H3ErrorCode(E_FAILED): The operation failed but a more specific error is not available"

end # module test_h3_api_errors
