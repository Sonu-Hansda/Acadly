const TryCatch = (passedFunction) => async(req , res , next) => {
    try {
        await passedFunction(req , res , next);
    } catch (error) {
        next(error);
    }
}

export { TryCatch};
