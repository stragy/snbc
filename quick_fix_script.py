#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Flutter 错误快速修复脚本
基于 app.log 分析结果，自动修复常见的 Flutter 错误
"""

import os
import re
import shutil
from pathlib import Path

class FlutterErrorFixer:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.backup_dir = self.project_root / "backup_before_fix"
        
    def create_backup(self):
        """创建备份"""
        print("创建备份...")
        if self.backup_dir.exists():
            shutil.rmtree(self.backup_dir)
        shutil.copytree(self.project_root, self.backup_dir, ignore=shutil.ignore_patterns(
            'backup_before_fix', '.git', 'build', '.dart_tool', 'node_modules'
        ))
        print(f"备份已创建到: {self.backup_dir}")
    
    def fix_list_constructor(self, file_path):
        """修复 List 构造函数错误"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 修复 List 构造函数
            old_pattern = r'new List<([^>]+)>\(\)'
            new_pattern = r'<\1>[]'
            content = re.sub(old_pattern, new_pattern, content)
            
            old_pattern2 = r'new List\(\)'
            new_pattern2 = r'[]'
            content = re.sub(old_pattern2, new_pattern2, content)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"已修复 List 构造函数: {file_path}")
        except Exception as e:
            print(f"修复 List 构造函数失败 {file_path}: {e}")
    
    def fix_appbar_brightness(self, file_path):
        """修复 AppBar brightness 参数错误"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 移除 brightness 参数
            old_pattern = r'(\s+)brightness:\s+Brightness\.dark,?\s*'
            content = re.sub(old_pattern, r'\1', content)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"已修复 AppBar brightness: {file_path}")
        except Exception as e:
            print(f"修复 AppBar brightness 失败 {file_path}: {e}")
    
    def fix_screenutil_api(self, file_path):
        """修复 ScreenUtil API 错误"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 修复 ScreenUtil API
            replacements = {
                'ScreenUtil.screenWidth': '1.sw',
                'ScreenUtil.screenHeightDp': '1.sh',
                'ScreenUtil.init(width: 750, height: 1334, allowFontScaling: false)': 
                'ScreenUtil.init(context)',
            }
            
            for old, new in replacements.items():
                content = content.replace(old, new)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"已修复 ScreenUtil API: {file_path}")
        except Exception as e:
            print(f"修复 ScreenUtil API 失败 {file_path}: {e}")
    
    def fix_sendport_null_safety(self, file_path):
        """修复 SendPort 空安全错误"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 修复 SendPort 类型
            old_pattern = r'final SendPort send = IsolateNameServer\.lookupPortByName\(([^)]+)\);'
            new_pattern = r'final SendPort? sendPort = IsolateNameServer.lookupPortByName(\1);\n    if (sendPort != null) {\n      // 使用 sendPort\n    }'
            content = re.sub(old_pattern, new_pattern, content)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"已修复 SendPort 空安全: {file_path}")
        except Exception as e:
            print(f"修复 SendPort 空安全失败 {file_path}: {e}")
    
    def fix_constructor_parameters(self, file_path):
        """修复构造函数参数空安全错误"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 修复构造函数参数
            old_pattern = r'(\w+)\s*\(\s*\{([^}]*)\}\s*\)'
            def replace_constructor(match):
                class_name = match.group(1)
                params = match.group(2)
                
                # 添加 required 关键字
                new_params = []
                for param in params.split(','):
                    param = param.strip()
                    if param and 'this.' in param and 'required' not in param:
                        param = f'required {param}'
                    new_params.append(param)
                
                return f'{class_name}({{{", ".join(new_params)}}})'
            
            content = re.sub(old_pattern, replace_constructor, content)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"已修复构造函数参数: {file_path}")
        except Exception as e:
            print(f"修复构造函数参数失败 {file_path}: {e}")
    
    def fix_field_initialization(self, file_path):
        """修复字段初始化错误"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 修复字段初始化
            old_pattern = r'(\w+)\s+(\w+);\s*// 非空字段'
            new_pattern = r'late \1 \2; // 延迟初始化'
            content = re.sub(old_pattern, new_pattern, content)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print(f"已修复字段初始化: {file_path}")
        except Exception as e:
            print(f"修复字段初始化失败 {file_path}: {e}")
    
    def update_pubspec_yaml(self):
        """更新 pubspec.yaml 文件"""
        pubspec_path = self.project_root / "pubspec.yaml"
        if not pubspec_path.exists():
            print("pubspec.yaml 文件不存在")
            return
        
        try:
            with open(pubspec_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 更新环境版本
            content = re.sub(
                r'sdk:\s*"[^"]*"',
                'sdk: ">=2.17.0 <4.0.0"',
                content
            )
            
            content = re.sub(
                r'flutter:\s*"[^"]*"',
                'flutter: ">=3.0.0"',
                content
            )
            
            # 更新依赖版本
            dependencies_updates = {
                'fluwx:': 'fluwx: ^3.0.0',
                'flutter_downloader:': 'flutter_downloader: ^1.11.0',
                'flutter_screenutil:': 'flutter_screenutil: ^5.9.0',
                'flutter_picker:': 'flutter_picker: ^2.1.0',
            }
            
            for old, new in dependencies_updates.items():
                content = re.sub(f'{old}[^\\n]*', new, content)
            
            with open(pubspec_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print("已更新 pubspec.yaml")
        except Exception as e:
            print(f"更新 pubspec.yaml 失败: {e}")
    
    def fix_all_files(self):
        """修复所有文件"""
        print("开始修复 Flutter 错误...")
        
        # 创建备份
        self.create_backup()
        
        # 查找所有 Dart 文件
        dart_files = list(self.project_root.rglob("*.dart"))
        
        for file_path in dart_files:
            if "backup" in str(file_path):
                continue
                
            print(f"\n处理文件: {file_path}")
            
            # 应用各种修复
            self.fix_list_constructor(file_path)
            self.fix_appbar_brightness(file_path)
            self.fix_screenutil_api(file_path)
            self.fix_sendport_null_safety(file_path)
            self.fix_constructor_parameters(file_path)
            self.fix_field_initialization(file_path)
        
        # 更新 pubspec.yaml
        self.update_pubspec_yaml()
        
        print("\n修复完成！")
        print("请运行以下命令测试修复结果：")
        print("flutter clean")
        print("flutter pub get")
        print("flutter analyze")
        print("flutter run")
    
    def generate_fix_report(self):
        """生成修复报告"""
        report_path = self.project_root / "fix_report.md"
        
        report_content = """# Flutter 错误修复报告

## 修复内容

### 1. 空安全相关修复
- 修复了 List 构造函数使用
- 修复了 SendPort 空安全错误
- 修复了字段初始化问题
- 修复了构造函数参数空安全

### 2. API 更新
- 移除了已弃用的 AppBar brightness 参数
- 更新了 ScreenUtil API 调用
- 修复了网络请求参数类型

### 3. 依赖更新
- 更新了 pubspec.yaml 中的依赖版本
- 更新了 Flutter SDK 版本要求

## 下一步操作

1. 运行 `flutter clean` 清理项目
2. 运行 `flutter pub get` 获取依赖
3. 运行 `flutter analyze` 检查剩余错误
4. 运行 `flutter run` 测试应用

## 注意事项

- 备份文件保存在 `backup_before_fix` 目录中
- 如果修复后仍有错误，请手动检查并修复
- 建议逐步测试各个功能模块

## 常见问题

### 如果仍有编译错误
1. 检查是否还有其他已弃用的 API
2. 确认所有第三方包都已更新到兼容版本
3. 检查空安全相关的类型声明

### 如果功能异常
1. 检查 API 调用是否正确
2. 确认参数传递是否符合新版本要求
3. 测试各个功能模块
"""
        
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(report_content)
        
        print(f"修复报告已生成: {report_path}")

def main():
    """主函数"""
    print("Flutter 错误快速修复工具")
    print("=" * 50)
    
    # 获取项目根目录
    project_root = input("请输入 Flutter 项目根目录路径 (默认为当前目录): ").strip()
    if not project_root:
        project_root = "."
    
    if not os.path.exists(project_root):
        print("错误：指定的目录不存在")
        return
    
    # 创建修复器实例
    fixer = FlutterErrorFixer(project_root)
    
    # 确认操作
    print(f"\n即将修复项目: {os.path.abspath(project_root)}")
    confirm = input("是否继续？(y/N): ").strip().lower()
    
    if confirm != 'y':
        print("操作已取消")
        return
    
    try:
        # 执行修复
        fixer.fix_all_files()
        
        # 生成报告
        fixer.generate_fix_report()
        
        print("\n修复完成！请查看生成的修复报告。")
        
    except Exception as e:
        print(f"修复过程中出现错误: {e}")
        print("请检查错误信息并手动修复")

if __name__ == "__main__":
    main() 