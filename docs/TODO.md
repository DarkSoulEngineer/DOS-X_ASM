# TODO - Feature Roadmap

Planned features and improvements for the Assembly Graphics Project.

 > [!NOTE]
> This is a living document. Update as features are completed or new ideas emerge.

## 🎨 Graphics & Drawing Features

### High Priority
- [x] Load Figures in RAM memory, display them on the screen
- [x] Implement Loading an scene saved on RAM memory
- [x] Implement Loading an bitmap from a file
- [x] Implement Saving an bitmap to a file
- [ ] Implement circle drawing (midpoint circle algorithm)

### Low Priority
- [ ] Add polygon drawing support

## 📋 Menu & UI Improvements

### High Priority
- [x] Add submenu support for better organization
- [x] Add help/info screen showing controls
- [ ] Add menu highlighting and better visual feedback
## ⚡ Performance & Optimization

### High Priority
- [ ] Optimize critical drawing loops
- [ ] Profile code and identify bottlenecks
- [ ] Optimize memory usage

### Medium Priority
- [ ] Add assembly optimization flags/techniques
- [ ] Implement look-up tables for frequently used values

## 📚 Documentation

### High Priority
- [ ] Add code comments to all procedures
- [ ] Create interrupt reference guide
- [ ] Document all drawing algorithms used
- [ ] Add troubleshooting guide to docs

### Medium Priority
- [ ] Create video tutorial or demo recording
- [ ] Add developer guide for extending the project
- [ ] Document memory layout and usage
- [ ] Create API reference for all modules
- [ ] Add examples and code snippets

### Low Priority
- [ ] Create project presentation slides
- [ ] Write blog post about the project
- [ ] Add performance benchmarks

## 🐛 Bug Fixes & QA

### High Priority
- [ ] Test all menu options thoroughly
- [ ] Verify graphics modes work correctly
- [ ] Check for memory leaks
- [ ] Test on different DOSBox configurations

### Medium Priority
- [ ] Add error handling for all file operations
- [ ] Implement graceful error recovery
- [ ] Add input validation everywhere
- [ ] Test edge cases (min/max values)

## 🎯 Project Quality

### High Priority
- [ ] Refactor duplicated code into shared procedures
- [ ] Standardize naming conventions across all modules
- [ ] Add consistent header comments to all files
- [ ] Remove unused/dead code

### Medium Priority
- [ ] Create coding style guide
- [ ] Add code review checklist
- [ ] Implement unit testing framework (if possible)
- [ ] Profile memory usage

## 🌟 Creative Features

### Fun Ideas (Low Priority)
- [ ] Add Easter eggs (hidden features)
- [ ] Create demo mode (auto-play demonstration)

## 📝 Notes

### Implementation Considerations
- Keep Assembly 8086 compatibility in mind
- Maintain small memory footprint (64KB limits)
- Optimize for DOSBox-X performance
- Document all interrupt usage
- Keep code modular and maintainable

### Priority Guidelines
- **High**: Core functionality, immediate value
- **Medium**: Nice-to-have, enhances experience
- **Low**: Polish, advanced features, experimentation

---

**Last Updated**: 2025-12-22  
**Status**: Planning Phase

## See Also
- [[01-Getting-Started/Project-Overview|Project Overview]] - Current features
- [[02-Technical/Architecture|Architecture]] - System design
- [[03-Reference/Modules|Modules]] - Current module documentation
