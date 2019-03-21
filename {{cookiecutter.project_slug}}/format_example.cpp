
// this file is used for formating reference, both for clang-format and clang-tidy

// check the link below, for available identifier naming checks of clang-tidy.
// https://clang.llvm.org/extra/clang-tidy/checks/readability-identifier-naming.html

namespace {{cookiecutter.project_namespace}} { // NamespaceCase: lower_case :
namespace {{cookiecutter.project_slug}} {

const int GLOBAL_CONSTANT = 12; // GlobalConstantCase: UPPER_CASE

// define default MemberCase: lower_case
// define default MethodCase: lower_case

struct MyStruct {          // StructCase: CamelCase
    int my_struct_member1; // MemberCase: lower_case
    int my_struct_member2;
};

class MyClass { // ClassCase: CamelCase

  private:
    int m_my_private; // MemberCase: lower_case, PrivateMemberPrefix: "m_"

  protected:
    int m_my_protected; // MemberCase: lower_case, ProtectedMemberPrefix: "m_"

  public:
    int my_public;                   // MemberCase: lower_case
    static const int CLASS_CONSTANT; // ClassConstantCase: UPPER_CASE

    void jump_twice() { // MethodCase: lower_case
    }
};

void some_function() {
    int local_var; // VariableCase: lower_case
}

} // namespace {{cookiecutter.project_slug}}
} // namespace {{cookiecutter.project_namespace}}

int main() { return 0; }
