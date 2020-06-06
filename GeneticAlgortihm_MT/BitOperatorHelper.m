function [outputVector] = BitOperatorHelper(inputVector)
%i.e. change bit 010 to 000 or 101 to 111, with a certain amount of 
%probability. For instance, bits 011 can be changed to bits 000 
%(probability of 25%) or 111 (probability of 75%) and similarly bits 100 
%to 000 (probability of 75%) or 111 (probability of 25%).
patterns(1).bits = [0,0,0];
patterns(2).bits = [0,0,1];
patterns(3).bits = [0,1,0];
patterns(4).bits = [0,1,1];
patterns(5).bits = [1,0,0];
patterns(6).bits = [1,0,1];
patterns(7).bits = [1,1,0];
patterns(8).bits = [1,1,1];

randNum = rand();

if inputVector == patterns(2).bits
    if randNum >= 0.25
        outputVector = patterns(1).bits;
    end
    if randNum < 0.25
        outputVector = patterns(8).bits;
    end
elseif inputVector == patterns(3).bits
    if randNum > 0.25
        outputVector = patterns(1).bits;
    end
    if randNum < 0.25
        outputVector = patterns(8).bits;
    end
elseif inputVector == patterns(4).bits
    if randNum > 0.25
        outputVector = patterns(8).bits;
    end
    if randNum < 0.25
        outputVector = patterns(1).bits;
    end
elseif inputVector == patterns(5).bits
    if randNum > 0.25
        outputVector = patterns(1).bits;
    end
    if randNum < 0.25
        outputVector = patterns(8).bits;
    end
elseif inputVector == patterns(6).bits
    if randNum > 0.25
        outputVector = patterns(8).bits;
    end
    if randNum < 0.25
        outputVector = patterns(1).bits;
    end
elseif inputVector == patterns(7).bits
    if randNum > 0.25
        outputVector = patterns(8).bits;
    end
    if randNum < 0.25
        outputVector = patterns(1).bits;
    end
else 
    outputVector = inputVector;
end

