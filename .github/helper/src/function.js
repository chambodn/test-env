export function printStuff() { console.log('stuff') }
export function checkEnv() { console.log('env') }
export function stringToList(changedFiles) {
    if(changedFiles) {
        return changedFiles.split(';');
    }
    return [];
}