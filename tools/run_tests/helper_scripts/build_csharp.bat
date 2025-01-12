@rem Copyright 2016 gRPC authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.

setlocal

cd /d %~dp0\..\..\..

mkdir cmake
cd cmake
mkdir build
cd build
mkdir %ARCHITECTURE%
cd %ARCHITECTURE%

cmake -G "Visual Studio 14 2015" -A %ARCHITECTURE% -DgRPC_BUILD_TESTS=OFF -DgRPC_MSVC_STATIC_RUNTIME=ON  -DgRPC_XDS_USER_AGENT_IS_CSHARP=ON -DgRPC_BUILD_MSVC_MP_COUNT=%GRPC_RUN_TESTS_JOBS% ../../.. || goto :error
cmake --build . --target grpc_csharp_ext --config %MSBUILD_CONFIG% || goto :error

cd ..\..\..\src\csharp

dotnet build --configuration %MSBUILD_CONFIG% Grpc.sln || goto :error

endlocal

goto :EOF

:error
echo Failed!
exit /b %errorlevel%
